# Philosophers - Concurrency & Synchronization

> A 42 School project exploring concurrency, synchronization, and resource management by solving the classic **Dining Philosophers** problem using threads, mutexes, and semaphores.

[![Language](https://img.shields.io/badge/language-C-blue.svg)]()
[![Concepts](https://img.shields.io/badge/concepts-Threads%2C%20Mutexes%2C%20Semaphores-orange.svg)]()
[![Status](https://img.shields.io/badge/status-In%20Development-yellow.svg)]()
[![Norm](https://img.shields.io/badge/norm-v4-success.svg)]()

## 📋 Table of Contents

- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Core Concepts](#core-concepts)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Testing Strategy](#testing-strategy)
- [Author](#author)

## 🎯 Overview

**Philosophers** is a classic synchronization problem designed to illustrate the challenges of avoiding deadlocks in a multi-threaded environment. The goal is to simulate a group of philosophers sitting at a round table who do nothing but think, eat, and sleep.

**Core Challenge**: Implement a simulation where multiple philosophers can eat from a shared set of forks without starving or causing a deadlock. The simulation must correctly handle resource allocation (forks) and prevent race conditions.

**Key Concepts Explored:**
- Concurrency: Managing multiple philosophers (threads/processes) executing simultaneously
- Synchronization: Using mutexes and semaphores to protect shared resources (forks)
- Deadlock Avoidance: Implementing strategies to ensure the simulation never freezes
- Race Condition Prevention: Ensuring that log messages and state changes are atomic

## 🔴 Problem Statement

**Given:**
- N philosophers sitting at a round table
- N forks, with one fork between each philosopher
- A central bowl of spaghetti that never runs out

**Goal:**
- Each philosopher must eat, sleep, and think in a cycle
- To eat, a philosopher needs to pick up both their left and right forks
- The simulation ends if a philosopher dies of starvation or, optionally, after everyone has eaten a certain number of times
- The primary goal is to write a program where philosophers never die

**Input Arguments:**
1. `number_of_philosophers` - The number of philosophers (and forks)
2. `time_to_die` (ms) - If a philosopher doesn't start eating within this time, they die
3. `time_to_eat` (ms) - Time it takes for a philosopher to eat
4. `time_to_sleep` (ms) - Time a philosopher spends sleeping
5. `[number_of_times_each_philosopher_must_eat]` (optional) - Simulation stops condition

**Log Output Format:**
All state changes logged to stdout: `timestamp_in_ms X [action]`
- Actions: `has taken a fork`, `is eating`, `is sleeping`, `is thinking`, `died`

## 🧠 Core Concepts

### The Deadlock Problem
The classic deadlock scenario occurs when all philosophers pick up their left fork simultaneously and then wait indefinitely for their right fork - creating a circular wait that freezes the program.

### Deadlock Avoidance Strategies
- **Odd/Even Pattern**: Philosophers with different IDs use different fork-picking orders
- **Staggered Start**: Introduce small delays for certain philosophers
- **Semaphore-based**: Use semaphores to limit concurrent access to resources

## 📦 Requirements

- **OS**: Linux / macOS
- **Compiler**: `cc` (GCC/Clang) with `-Wall -Wextra -Werror`
- **Threading**: POSIX Threads (`pthread`)
- **Synchronization**: Mutexes and/or Semaphores
- **Makefile**: Must include `all`, `clean`, `fclean`, `re`, and `bonus` rules

## 🚀 Installation

```bash
# Clone the repository
git clone https://github.com/carolinecbahia/philosophers.git
cd philosophers

# Build the mandatory part (threads & mutexes)
make

# Build the bonus part (processes & semaphores)
make bonus
```

## 💻 Usage

### Mandatory Program (Threads & Mutexes)

```bash
./philo <number_of_philosophers> <time_to_die> <time_to_eat> <time_to_sleep> [must_eat]

# Examples:
./philo 5 800 200 200
./philo 5 800 200 200 7
```

### Bonus Program (Processes & Semaphores)

```bash
./philo_bonus <number_of_philosophers> <time_to_die> <time_to_eat> <time_to_sleep> [must_eat]

# Example:
./philo_bonus 5 800 200 200 7
```

## 🏗️ Project Structure

```
philosophers/
├── src/                       # Implementation files
│   └── [implementation files]
├── includes/                  # Header files
│   └── philosophers.h
├── Makefile                   # Build configuration
└── README.md
```

## 🧪 Testing Strategy

The project will be tested for:
- **Correctness**: Philosophers never die with valid inputs
- **Data Races**: Verified using thread sanitizers
- **Deadlocks**: Tested with stressful parameters
- **Memory Safety**: Verified with valgrind
- **Output Format**: Correct logging of all state transitions

## 📚 Key Concepts

### Mandatory Part - Threads & Mutexes
- Each philosopher is a separate thread
- Each fork is protected by a mutex
- Central monitor thread checks for philosopher starvation
- Write operations protected by mutex to prevent output interleaving

### Bonus Part - Processes & Semaphores
- Each philosopher is a separate process (fork())
- Forks managed by a single semaphore
- Processes communicate through semaphores
- Zombie process handling with waitpid()

## 🎓 About 42 School

The **42 School** is a coding school that emphasizes peer learning and practical programming skills. The Philosophers project teaches:
- Deep understanding of concurrency and synchronization primitives
- How to think about and prevent deadlocks
- Practical use of POSIX threading and IPC mechanisms
- Debugging and testing multi-threaded applications

## 📝 Project Status

**Current Status**: In Development

This project is actively being developed. Code implementation details will be documented once the project reaches a stable state.

## 📄 License

This project is part of the 42 School curriculum.

## ✍️ Author

**Caroline Bahia**
- GitHub: [@carolinecbahia](https://github.com/carolinecbahia)
- 42 School: cbahia

---

**Status**: In Progress  
**Repository**: [GitHub Philosophers](https://github.com/carolinecbahia/philosophers)