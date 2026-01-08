#!/bin/bash

# Quick Test Examples for Philosophers Project
# Run individual test cases manually

echo "=== PHILOSOPHERS QUICK TEST EXAMPLES ==="
echo ""
echo "📋 Test Categories:"
echo ""

echo "1️⃣  SINGLE PHILOSOPHER (must die):"
echo "   ./philo 1 800 200 200"
echo ""

echo "2️⃣  BASIC TESTS (no death):"
echo "   ./philo 5 800 200 200"
echo "   ./philo 4 410 200 200"
echo ""

echo "3️⃣  DEATH TESTS:"
echo "   ./philo 4 310 200 100    # Should die ~310ms"
echo ""

echo "4️⃣  MEAL COUNT:"
echo "   ./philo 5 800 200 200 7  # Stop after 7 meals"
echo ""

echo "5️⃣  TWO PHILOSOPHERS:"
echo "   ./philo 2 400 200 200"
echo "   ./philo 2 800 200 200"
echo ""

echo "6️⃣  LARGE NUMBER:"
echo "   ./philo 100 800 200 200"
echo "   ./philo 200 800 200 200"
echo ""

echo "7️⃣  TIGHT TIMING:"
echo "   ./philo 3 300 100 100"
echo "   ./philo 4 210 100 100"
echo ""

echo "8️⃣  BONUS (if compiled):"
echo "   ./philo_bonus 5 800 200 200"
echo "   ./philo_bonus 4 410 200 200 10"
echo ""

echo "🔍 DEBUGGING:"
echo "   valgrind --leak-check=full ./philo 4 410 200 200 5"
echo "   ./philo_tsan 4 410 200 200 5  # After compiling with ./compile_tsan.sh"
echo ""

echo "🚀 RUN ALL TESTS:"
echo "   ./test_philosophers.sh all"
echo ""
