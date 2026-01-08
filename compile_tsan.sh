#!/bin/bash

# ============================================================================
# COMPILE TSAN - Compile philosophers with Thread Sanitizer
# ============================================================================
# This script compiles the philosophers project with thread sanitizer
# to detect data races and threading issues
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Compiling philosophers with Thread Sanitizer...${NC}"

# Check if source files exist
if [ ! -d "src" ]; then
    echo -e "${RED}Error: src/ directory not found!${NC}"
    exit 1
fi

if [ ! -d "includes" ]; then
    echo -e "${RED}Error: includes/ directory not found!${NC}"
    exit 1
fi

# Compile with thread sanitizer
cc -g -fsanitize=thread \
   -Wall -Wextra -Werror \
   -pthread \
   -o philo_tsan \
   src/*.c \
   -I includes

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Compilation successful!${NC}"
    echo -e "${CYAN}Run with: ./philo_tsan [args]${NC}"
    echo -e "${YELLOW}Note: TSan may slow down execution significantly${NC}"
else
    echo -e "${RED}✗ Compilation failed!${NC}"
    exit 1
fi
