#!/bin/bash

# ============================================================================
# PHILOSOPHERS OUTPUT CHECKER
# ============================================================================
# Analyzes philosophers output for common issues
# Usage: ./philo [args] | ./check_output.sh
# Or:    ./philo [args] > output.log && ./check_output.sh output.log
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

input_file="${1:-/dev/stdin}"

# Read input
if [ "$input_file" = "/dev/stdin" ]; then
    output=$(cat)
else
    if [ ! -f "$input_file" ]; then
        echo -e "${RED}Error: File $input_file not found${NC}"
        exit 1
    fi
    output=$(cat "$input_file")
fi

echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}           PHILOSOPHERS OUTPUT ANALYSIS${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Total lines
total_lines=$(echo "$output" | wc -l)
echo -e "${CYAN}📊 Total output lines:${NC} $total_lines"

# Check for death
death_count=$(echo "$output" | grep -ci "died")
if [ $death_count -gt 0 ]; then
    echo -e "${RED}💀 Deaths detected:${NC} $death_count"
    echo "$output" | grep -i "died" | head -5
else
    echo -e "${GREEN}✓ No deaths detected${NC}"
fi
echo ""

# Check for eating
eat_count=$(echo "$output" | grep -c "is eating")
echo -e "${CYAN}🍝 Total eating events:${NC} $eat_count"

# Check each philosopher's eating count
max_philo=$(echo "$output" | grep -oE "^[0-9]+ [0-9]+" | awk '{print $2}' | sort -n | tail -1)
if [ -n "$max_philo" ]; then
    echo -e "${CYAN}👥 Number of philosophers:${NC} $max_philo"
    echo ""
    echo -e "${CYAN}Eating distribution:${NC}"
    for ((i=1; i<=max_philo; i++)); do
        philo_eats=$(echo "$output" | grep -E "^[0-9]+ $i is eating" | wc -l)
        echo -e "  Philosopher $i: $philo_eats meals"
    done
fi
echo ""

# Check for thinking
think_count=$(echo "$output" | grep -c "is thinking")
echo -e "${CYAN}💭 Thinking events:${NC} $think_count"

# Check for sleeping
sleep_count=$(echo "$output" | grep -c "is sleeping")
echo -e "${CYAN}😴 Sleeping events:${NC} $sleep_count"

# Check for fork taking
fork_count=$(echo "$output" | grep -c "has taken a fork")
echo -e "${CYAN}🍴 Fork takes:${NC} $fork_count"
echo ""

# Check timing
first_timestamp=$(echo "$output" | head -1 | grep -oE "^[0-9]+")
last_timestamp=$(echo "$output" | tail -1 | grep -oE "^[0-9]+")

if [ -n "$first_timestamp" ] && [ -n "$last_timestamp" ]; then
    duration=$((last_timestamp - first_timestamp))
    echo -e "${CYAN}⏱️  First timestamp:${NC} ${first_timestamp}ms"
    echo -e "${CYAN}⏱️  Last timestamp:${NC} ${last_timestamp}ms"
    echo -e "${CYAN}⏱️  Simulation duration:${NC} ${duration}ms"
fi
echo ""

# Check for timing issues
echo -e "${CYAN}🔍 Checking for issues...${NC}"
issues=0

# Check if messages are not in order (timestamps should increase)
prev=0
disorder=0
while IFS= read -r line; do
    ts=$(echo "$line" | grep -oE "^[0-9]+")
    if [ -n "$ts" ] && [ $ts -lt $prev ]; then
        ((disorder++))
    fi
    prev=$ts
done < <(echo "$output")

if [ $disorder -gt 0 ]; then
    echo -e "${RED}  ✗ Timestamps out of order: $disorder times${NC}"
    ((issues++))
else
    echo -e "${GREEN}  ✓ Timestamps in order${NC}"
fi

# Check for duplicate timestamps (potential race condition)
dup_count=$(echo "$output" | grep -oE "^[0-9]+" | sort | uniq -d | wc -l)
if [ $dup_count -gt 5 ]; then
    echo -e "${YELLOW}  ⚠ Many duplicate timestamps: $dup_count (possible race condition)${NC}"
fi

# Check if philosophers took forks before eating
fork_before_eat=true
if [ $fork_count -lt $eat_count ]; then
    echo -e "${RED}  ✗ More eating than fork takes (impossible!)${NC}"
    ((issues++))
    fork_before_eat=false
fi

if [ "$fork_before_eat" = true ]; then
    echo -e "${GREEN}  ✓ Fork takes match eating events${NC}"
fi

# Check for death timing (if death occurred)
if [ $death_count -gt 0 ]; then
    death_line=$(echo "$output" | grep -i "died" | head -1)
    death_time=$(echo "$death_line" | grep -oE "^[0-9]+")
    philo_num=$(echo "$death_line" | grep -oE "^[0-9]+ [0-9]+" | awk '{print $2}')
    
    if [ -n "$philo_num" ]; then
        last_eat=$(echo "$output" | grep -E "^[0-9]+ $philo_num is eating" | tail -1 | grep -oE "^[0-9]+")
        if [ -n "$last_eat" ]; then
            time_since_eat=$((death_time - last_eat))
            echo ""
            echo -e "${YELLOW}Death Analysis:${NC}"
            echo -e "  Philosopher $philo_num died at ${death_time}ms"
            echo -e "  Last ate at ${last_eat}ms"
            echo -e "  Time since last meal: ${time_since_eat}ms"
        fi
    fi
fi

echo ""
if [ $issues -eq 0 ]; then
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}           ✓ NO CRITICAL ISSUES DETECTED${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
else
    echo -e "${RED}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}           ✗ $issues CRITICAL ISSUE(S) DETECTED${NC}"
    echo -e "${RED}═══════════════════════════════════════════════════════════════${NC}"
fi
echo ""
