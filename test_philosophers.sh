#!/bin/bash

# ============================================================================
# PHILOSOPHERS TEST SCRIPT - Comprehensive Edge Cases Testing
# ============================================================================
# Tests both mandatory and bonus parts with extreme cases
# Usage: ./test_philosophers.sh [mandatory|bonus|all]
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Executables
PHILO_EXEC="./philo"
PHILO_BONUS_EXEC="./philo_bonus"

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_header() {
    echo ""
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}  $1${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_test() {
    echo -e "${BLUE}[TEST ${TOTAL_TESTS}]${NC} $1"
}

print_command() {
    echo -e "${MAGENTA}  Command:${NC} $1"
}

print_success() {
    echo -e "${GREEN}  ✓ PASSED${NC} - $1"
    echo ""
    ((PASSED_TESTS++))
}

print_failure() {
    echo -e "${RED}  ✗ FAILED${NC} - $1"
    echo ""
    ((FAILED_TESTS++))
}

print_warning() {
    echo -e "${YELLOW}  ⚠ WARNING${NC} - $1"
}

print_info() {
    echo -e "${CYAN}  ℹ INFO${NC} - $1"
}

check_executable() {
    if [ ! -f "$1" ]; then
        echo -e "${RED}Error: $1 not found!${NC}"
        echo -e "${YELLOW}Please compile first: make${NC}"
        exit 1
    fi
    
    if [ ! -x "$1" ]; then
        echo -e "${RED}Error: $1 is not executable!${NC}"
        chmod +x "$1"
    fi
}

# ============================================================================
# TEST EXECUTION FUNCTIONS
# ============================================================================

run_test_no_death() {
    local exec=$1
    shift
    # Last argument is timeout in seconds, rest are program arguments
    local timeout="${!#}"  # Get last argument
    local args=("$@")
    unset 'args[-1]'  # Remove last element (timeout)
    local prog_args="${args[@]}"
    
    ((TOTAL_TESTS++))
    print_test "No philosopher should die"
    print_command "$exec $prog_args"
    
    timeout ${timeout}s $exec $prog_args > /tmp/philo_test.log 2>&1
    local exit_code=$?
    
    if [ $exit_code -eq 124 ]; then
        print_failure "Test timed out (this might be expected for some tests)"
        return 1
    fi
    
    if grep -qi "died" /tmp/philo_test.log; then
        print_failure "A philosopher died when they shouldn't have"
        echo -e "${YELLOW}Last lines of output:${NC}"
        tail -10 /tmp/philo_test.log
        return 1
    fi
    
    print_success "No deaths detected in the time frame"
    return 0
}

run_test_should_die() {
    local exec=$1
    shift
    local args="$@"
    # Arguments after shift: num_philos time_to_die time_to_eat time_to_sleep expected_death
    local num_philos=$1
    local time_to_die=$2
    local time_to_eat=$3
    local time_to_sleep=$4
    local expected_death=$5
    
    ((TOTAL_TESTS++))
    print_test "Philosopher should die around ${expected_death}ms"
    print_command "$exec $num_philos $time_to_die $time_to_eat $time_to_sleep"
    
    timeout 15s $exec $num_philos $time_to_die $time_to_eat $time_to_sleep > /tmp/philo_test.log 2>&1
    
    if ! grep -qi "died" /tmp/philo_test.log; then
        print_failure "No philosopher died when one should have"
        if [ ${DEBUG:-0} -eq 1 ]; then
            echo -e "${YELLOW}Output (first 30 lines):${NC}"
            head -30 /tmp/philo_test.log
            echo -e "${YELLOW}Output (last 10 lines):${NC}"
            tail -10 /tmp/philo_test.log
        fi
        return 1
    fi
    
    # Extract death time
    local death_line=$(grep -i "died" /tmp/philo_test.log | head -1)
    local death_time=$(echo "$death_line" | grep -oE '^[0-9]+')
    
    if [ -z "$death_time" ]; then
        print_warning "Could not parse death time from output"
        print_success "But a philosopher did die as expected"
        return 0
    fi
    
    local lower_bound=$((expected_death - 10))
    local upper_bound=$((expected_death + 10))
    
    if [ $death_time -ge $lower_bound ] && [ $death_time -le $upper_bound ]; then
        print_success "Philosopher died at ${death_time}ms (expected ~${expected_death}ms)"
        return 0
    else
        print_failure "Philosopher died at ${death_time}ms (expected ~${expected_death}ms ±10ms)"
        return 1
    fi
}

run_test_meal_count() {
    local exec=$1
    shift
    # Store all arguments for execution
    local args="$@"
    # Parse individual arguments correctly
    local num_philos=$1
    local time_to_die=$2
    local time_to_eat=$3
    local time_to_sleep=$4
    local meals=$5
    
    ((TOTAL_TESTS++))
    print_test "All philosophers should eat $meals times and simulation should stop"
    print_command "$exec $args"
    
    timeout 30s $exec $args > /tmp/philo_test.log 2>&1
    local exit_code=$?
    
    if [ $exit_code -eq 124 ]; then
        print_failure "Test timed out - simulation didn't stop after all ate $meals times"
        return 1
    fi
    
    if grep -qi "died" /tmp/philo_test.log; then
        print_failure "A philosopher died before eating $meals times"
        return 1
    fi
    
    # Check if output is empty or too short
    local line_count=$(wc -l < /tmp/philo_test.log)
    if [ $line_count -eq 0 ]; then
        print_failure "No output generated by the program"
        return 1
    elif [ $line_count -lt 10 ]; then
        print_warning "Very few lines of output ($line_count lines)"
        echo "Output:"
        cat /tmp/philo_test.log
    fi
    
    # Count eating messages per philosopher
    local all_ate_enough=1
    for ((i=1; i<=num_philos; i++)); do
        local eat_count=$(grep -cE "^[0-9]+ $i is eating" /tmp/philo_test.log)
        if [ $eat_count -lt $meals ]; then
            all_ate_enough=0
            print_warning "Philosopher $i only ate $eat_count times (expected $meals)"
        fi
    done
    
    if [ $all_ate_enough -eq 1 ]; then
        print_success "All philosophers ate at least $meals times"
        return 0
    else
        print_failure "Not all philosophers ate enough times"
        if [ ${DEBUG:-0} -eq 1 ]; then
            echo "First 20 lines of output:"
            head -20 /tmp/philo_test.log
        fi
        return 1
    fi
}

run_test_no_crash() {
    local exec=$1
    shift
    local args="$@"
    
    ((TOTAL_TESTS++))
    print_test "Program should not crash"
    print_command "$exec $args"
    
    timeout 5s $exec $args > /tmp/philo_test.log 2>&1
    local exit_code=$?
    
    if [ $exit_code -eq 139 ]; then
        print_failure "Segmentation fault detected"
        return 1
    elif [ $exit_code -eq 134 ]; then
        print_failure "Abort signal (possibly assertion failure)"
        return 1
    elif [ $exit_code -eq 135 ]; then
        print_failure "Bus error detected"
        return 1
    fi
    
    print_success "No crash detected"
    return 0
}

run_stress_test() {
    local exec=$1
    shift
    # Last argument is duration in seconds, rest are program arguments
    local duration="${!#}"
    local args=("$@")
    unset 'args[-1]'  # Remove last element (duration)
    local prog_args="${args[@]}"
    
    ((TOTAL_TESTS++))
    print_test "Stress test - running for ${duration}s"
    print_command "$exec $prog_args"
    
    timeout ${duration}s $exec $prog_args > /tmp/philo_test.log 2>&1
    
    if grep -qi "died" /tmp/philo_test.log; then
        print_failure "A philosopher died during stress test"
        return 1
    fi
    
    # Check for data races (if running with thread sanitizer)
    if grep -qi "data race\|race condition" /tmp/philo_test.log; then
        print_failure "Data race detected!"
        return 1
    fi
    
    print_success "Stress test completed without deaths"
    return 0
}

# ============================================================================
# MANDATORY TESTS
# ============================================================================

test_mandatory() {
    print_header "MANDATORY PART - PHILO"
    
    check_executable "$PHILO_EXEC"
    
    echo -e "${BOLD}${YELLOW}Category: Edge Cases - Single Philosopher${NC}"
    run_test_should_die "$PHILO_EXEC" 1 800 200 200 800
    run_test_should_die "$PHILO_EXEC" 1 400 200 200 400
    run_test_should_die "$PHILO_EXEC" 1 200 100 100 200
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Edge Cases - Two Philosophers${NC}"
    run_test_should_die "$PHILO_EXEC" 2 300 200 100 300
    run_test_no_death "$PHILO_EXEC" 2 400 200 200 5
    run_test_no_death "$PHILO_EXEC" 2 800 200 200 5
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Subject Tests - No Death Cases${NC}"
    run_test_no_death "$PHILO_EXEC" 5 800 200 200 10
    run_test_no_death "$PHILO_EXEC" 4 410 200 200 10
    run_test_no_death "$PHILO_EXEC" 4 310 200 100 10
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Subject Tests - Death Cases${NC}"
    run_test_should_die "$PHILO_EXEC" 4 310 200 100 310
    run_test_should_die "$PHILO_EXEC" 5 800 200 200 800
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Edge Cases - Tight Timing${NC}"
    run_test_no_death "$PHILO_EXEC" 3 300 100 100 10
    run_test_no_death "$PHILO_EXEC" 3 400 100 100 5
    run_test_should_die "$PHILO_EXEC" 3 200 150 100 200
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Large Number of Philosophers${NC}"
    run_test_no_death "$PHILO_EXEC" 100 800 200 200 10
    run_test_no_death "$PHILO_EXEC" 200 800 200 200 7
    
    # Medium stress test (skip with SKIP_STRESS=1)
    if [ "${SKIP_STRESS:-0}" -eq 0 ]; then
        run_stress_test "$PHILO_EXEC" 50 410 200 200 20
    fi
    
    # NOTE: Meal count tests are BONUS functionality only
    # The mandatory part only accepts 4 arguments (no meal count)
    # echo ""
    # echo -e "${BOLD}${YELLOW}Category: Meal Count Tests${NC}"
    # run_test_meal_count "$PHILO_EXEC" 4 500 200 200 5
    # run_test_meal_count "$PHILO_EXEC" 5 800 200 200 7
    # run_test_meal_count "$PHILO_EXEC" 3 610 200 200 10
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Extreme Timing${NC}"
    run_test_no_death "$PHILO_EXEC" 4 2000 500 500 5
    run_test_no_death "$PHILO_EXEC" 5 100 50 50 5
    run_test_should_die "$PHILO_EXEC" 4 50 100 100 50
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Odd Number of Philosophers${NC}"
    run_test_no_death "$PHILO_EXEC" 3 610 200 200 5
    run_test_no_death "$PHILO_EXEC" 5 800 200 200 7
    run_test_no_death "$PHILO_EXEC" 7 800 200 200 5
    run_test_no_death "$PHILO_EXEC" 9 800 200 200 5
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Invalid Arguments${NC}"
    run_test_no_crash "$PHILO_EXEC" 0 800 200 200
    run_test_no_crash "$PHILO_EXEC" -1 800 200 200
    run_test_no_crash "$PHILO_EXEC" 4 -1 200 200
    run_test_no_crash "$PHILO_EXEC" 4 800 -1 200
    run_test_no_crash "$PHILO_EXEC" 4 800 200 -1
    run_test_no_crash "$PHILO_EXEC" 2147483648 800 200 200
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Minimum Timing${NC}"
    run_test_no_death "$PHILO_EXEC" 4 210 100 100 5
    run_test_no_death "$PHILO_EXEC" 5 300 150 150 5
    
    # Stress tests (skip with SKIP_STRESS=1)
    if [ "${SKIP_STRESS:-0}" -eq 0 ]; then
        echo ""
        echo -e "${BOLD}${YELLOW}Category: Stress Tests${NC}"
        run_stress_test "$PHILO_EXEC" 100 800 200 200 30
        run_stress_test "$PHILO_EXEC" 200 1000 300 300 15
    else
        print_info "Skipping stress tests (SKIP_STRESS=1)"
    fi
}

# ============================================================================
# BONUS TESTS
# ============================================================================

test_bonus() {
    print_header "BONUS PART - PHILO_BONUS (Semaphores & Processes)"
    
    if [ ! -f "$PHILO_BONUS_EXEC" ]; then
        echo -e "${YELLOW}Bonus executable not found. Skipping bonus tests.${NC}"
        echo -e "${CYAN}Compile with: make bonus${NC}"
        return
    fi
    
    check_executable "$PHILO_BONUS_EXEC"
    
    echo -e "${BOLD}${YELLOW}Category: Basic Bonus Tests${NC}"
    run_test_no_death "$PHILO_BONUS_EXEC" 5 800 200 200 10
    run_test_should_die "$PHILO_BONUS_EXEC" 1 800 200 200 800
    run_test_should_die "$PHILO_BONUS_EXEC" 4 310 200 100 310
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Process Handling${NC}"
    run_test_no_death "$PHILO_BONUS_EXEC" 4 410 200 200 10
    run_test_meal_count "$PHILO_BONUS_EXEC" 5 800 200 200 7
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Large Number (Processes)${NC}"
    run_test_no_death "$PHILO_BONUS_EXEC" 50 800 200 200 10
    run_test_no_death "$PHILO_BONUS_EXEC" 100 800 200 200 7
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Edge Cases${NC}"
    run_test_should_die "$PHILO_BONUS_EXEC" 2 300 200 100 300
    run_test_no_death "$PHILO_BONUS_EXEC" 3 610 200 200 5
    run_test_no_death "$PHILO_BONUS_EXEC" 7 800 200 200 5
    
    echo ""
    echo -e "${BOLD}${YELLOW}Category: Semaphore Stress Test${NC}"
    run_stress_test "$PHILO_BONUS_EXEC" 100 800 200 200 20
    run_stress_test "$PHILO_BONUS_EXEC" 50 410 200 200 15
}

# ============================================================================
# MEMORY & DATA RACE CHECKS
# ============================================================================

test_memory_leaks() {
    print_header "MEMORY LEAK CHECKS (Valgrind)"
    
    if ! command -v valgrind &> /dev/null; then
        echo -e "${YELLOW}Valgrind not found. Skipping memory leak tests.${NC}"
        echo -e "${CYAN}Install with: sudo apt-get install valgrind${NC}"
        return
    fi
    
    ((TOTAL_TESTS++))
    print_test "Memory leak check - mandatory"
    print_command "valgrind --leak-check=full $PHILO_EXEC 4 410 200 200 5"
    
    timeout 15s valgrind --leak-check=full --error-exitcode=1 \
        $PHILO_EXEC 4 410 200 200 5 > /tmp/philo_valgrind.log 2>&1
    
    if [ $? -eq 0 ]; then
        print_success "No memory leaks detected"
    else
        print_failure "Memory leaks detected"
        grep -A 5 "LEAK SUMMARY" /tmp/philo_valgrind.log
    fi
}

test_data_races() {
    print_header "DATA RACE CHECKS (Thread Sanitizer)"
    
    if [ ! -f "./philo_tsan" ]; then
        echo -e "${YELLOW}Thread sanitizer build not found.${NC}"
        echo -e "${CYAN}Compile with: make tsan${NC}"
        echo -e "${CYAN}or: cc -g -fsanitize=thread -o philo_tsan src/*.c${NC}"
        return
    fi
    
    ((TOTAL_TESTS++))
    print_test "Data race check"
    print_command "./philo_tsan 4 410 200 200 5"
    
    timeout 15s ./philo_tsan 4 410 200 200 5 > /tmp/philo_tsan.log 2>&1
    
    if grep -qi "ThreadSanitizer: data race" /tmp/philo_tsan.log; then
        print_failure "Data race detected!"
        grep -A 10 "ThreadSanitizer: data race" /tmp/philo_tsan.log
    else
        print_success "No data races detected"
    fi
}

# ============================================================================
# SUMMARY
# ============================================================================

print_summary() {
    print_header "TEST SUMMARY"
    
    echo -e "${BOLD}Total Tests:${NC}  ${TOTAL_TESTS}"
    echo -e "${GREEN}${BOLD}Passed:${NC}       ${PASSED_TESTS}"
    echo -e "${RED}${BOLD}Failed:${NC}       ${FAILED_TESTS}"
    echo ""
    
    local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    
    if [ $success_rate -eq 100 ]; then
        echo -e "${GREEN}${BOLD}🎉 ALL TESTS PASSED! 🎉${NC}"
    elif [ $success_rate -ge 80 ]; then
        echo -e "${YELLOW}${BOLD}⚠  Most tests passed (${success_rate}%)${NC}"
    else
        echo -e "${RED}${BOLD}❌ Many tests failed (${success_rate}%)${NC}"
    fi
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    local test_mode="${1:-all}"
    
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║         PHILOSOPHERS COMPREHENSIVE TEST SUITE                ║"
    echo "║              Testing Edge Cases & Scenarios                  ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    print_info "Test mode: ${test_mode}"
    print_info "Date: $(date)"
    echo ""
    
    case $test_mode in
        mandatory)
            test_mandatory
            ;;
        bonus)
            test_bonus
            ;;
        memory)
            test_memory_leaks
            ;;
        tsan)
            test_data_races
            ;;
        all)
            test_mandatory
            test_bonus
            test_memory_leaks
            test_data_races
            ;;
        *)
            echo -e "${RED}Invalid test mode: $test_mode${NC}"
            echo -e "${CYAN}Usage: $0 [mandatory|bonus|memory|tsan|all]${NC}"
            exit 1
            ;;
    esac
    
    print_summary
    
    # Cleanup
    rm -f /tmp/philo_test.log /tmp/philo_valgrind.log /tmp/philo_tsan.log
    
    # Exit with appropriate code
    if [ $FAILED_TESTS -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main with all arguments
main "$@"
