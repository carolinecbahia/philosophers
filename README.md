# Philosophers - Concurrency & Synchronization

> A 42 School project exploring concurrency, synchronization, and resource management by solving the classic **Dining Philosophers** problem using threads, mutexes, and semaphores.

[![Language](https://img.shields.io/badge/language-C-blue.svg)]()
[![Concepts](https://img.shields.io/badge/concepts-Threads%2C%20Mutexes%2C%20Semaphores-orange.svg)]()
[![Status](https://img.shields.io/badge/status-In%20Progress-yellow.svg)]()
[![Norm](https://img.shields.io/badge/norm-v4-success.svg)]()

## 📋 Table of Contents

- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Core Concepts](#core-concepts)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Mandatory Part](#mandatory-part-threads--mutexes)
- [Bonus Part](#bonus-part-processes--semaphores)
- [Testing Strategy](#testing-strategy)
- [Project Structure](#project-structure)
- [Author](#author)

## 🎯 Overview

**Philosophers** is a classic synchronization problem designed to illustrate the challenges of avoiding deadlocks in a multi-threaded environment. The goal is to simulate a group of philosophers sitting at a round table who do nothing but think, eat, and sleep.

**Core Challenge**: Implement a simulation where multiple philosophers can eat from a shared set of forks without starving or causing a deadlock. The simulation must correctly handle resource allocation (forks) and prevent race conditions.

**Key Concepts Explored:**
- ✅ **Concurrency**: Managing multiple philosophers (threads/processes) executing simultaneously.
- ✅ **Synchronization**: Using mutexes and semaphores to protect shared resources (forks).
- ✅ **Deadlock Avoidance**: Implementing strategies to ensure the simulation never freezes.
- ✅ **Race Condition Prevention**: Ensuring that log messages and state changes are atomic.

## 🔴 Problem Statement

Given:
- **N** philosophers sitting at a round table.
- **N** forks, with one fork between each philosopher.
- A central bowl of spaghetti that never runs out.

Goal:
- Each philosopher must eat, sleep, and think in a cycle.
- To eat, a philosopher needs to pick up both their left and right forks.
- The simulation ends if a philosopher dies of starvation or, optionally, after everyone has eaten a certain number of times.
- The primary goal is to write a program where **philosophers never die**.

### Input Arguments
Your program must accept the following arguments:
1.  `number_of_philosophers`: The number of philosophers (and forks).
2.  `time_to_die` (ms): If a philosopher doesn't start eating within this time since their last meal, they die.
3.  `time_to_eat` (ms): Time it takes for a philosopher to eat.
4.  `time_to_sleep` (ms): Time a philosopher spends sleeping.
5.  `[number_of_times_each_philosopher_must_eat]` (optional): The simulation stops after every philosopher has eaten this many times.

### Log Output
All state changes must be logged to the standard output in the format:
`timestamp_in_ms X [action]`
- `timestamp_in_ms`: Milliseconds since the program started.
- `X`: The philosopher's number.
- `[action]`: `has taken a fork`, `is eating`, `is sleeping`, `is thinking`, or `died`.

## 🧠 Core Concepts

### The Deadlock Problem
The most common issue is **deadlock**:
1.  Every philosopher picks up their left fork simultaneously.
2.  Now, every philosopher is waiting for their right fork, which is held by their neighbor.
3.  Since everyone is waiting, no one can proceed. The program freezes.

### Deadlock Avoidance Strategy
A common solution is to break the symmetry of the resource request:
- **Odd/Even Philosophers**: Philosophers with an odd ID pick up their left fork first, then their right. Even philosophers pick up their right fork first, then their left. This prevents the circular wait condition.
- **Delayed Start**: Introduce a small, staggered delay (`usleep`) for even-numbered philosophers before they start their routine.

## 📦 Requirements

- **OS**: Linux / macOS
- **Compiler**: `cc` (GCC/Clang) with `-Wall -Wextra -Werror`
- **Threads**: POSIX Threads (`pthread`)
- **Makefile**: Must include `all`, `clean`, `fclean`, `re`, and `bonus` rules.
- **Forbidden**: Global variables.

## 🚀 Installation

```bash
# Clone the repository
git clone [your-repo-url]
cd philosophers

# Build the mandatory part
make

# Build the bonus part
make bonus
```

## 💻 Usage

### Mandatory Program (`philo`)

```bash
# 5 philosophers, die time 800ms, eat time 200ms, sleep time 200ms
./philo 5 800 200 200

# Simulation stops after each has eaten 7 times
./philo 5 800 200 200 7
```

### Bonus Program (`philo_bonus`)

```bash
# Same arguments, but uses processes and semaphores
./philo_bonus 5 800 200 200 7
```

## 🔩 Mandatory Part (Threads & Mutexes)

- **Program Name**: `philo`
- **External Functions**: `memset`, `printf`, `malloc`, `free`, `write`, `usleep`, `gettimeofday`, `pthread_create`, `pthread_detach`, `pthread_join`, `pthread_mutex_init`, `pthread_mutex_destroy`, `pthread_mutex_lock`, `pthread_mutex_unlock`.
- **Description**: Each philosopher is a thread (`pthread`), and each fork is a mutex (`pthread_mutex_t`).

### Implementation Details
- A central thread (the main thread) is responsible for monitoring the philosophers' health and determining if one has died.
- Each fork is a mutex. To eat, a philosopher must successfully lock the mutexes for both their left and right forks.
- A separate mutex is used to protect the `write` function to prevent interleaved log messages.

```c
// Simplified philosopher routine
void *philosopher_routine(void *arg)
{
    t_philosopher *philo = (t_philosopher *)arg;

    while (simulation_is_running())
    {
        // THINKING
        log_state(philo, THINKING);

        // EATING
        pthread_mutex_lock(philo->left_fork);
        log_state(philo, TOOK_FORK);
        pthread_mutex_lock(philo->right_fork);
        log_state(philo, TOOK_FORK);

        log_state(philo, EATING);
        philo->last_meal_time = get_current_time();
        usleep(philo->rules->time_to_eat * 1000);

        pthread_mutex_unlock(philo->left_fork);
        pthread_mutex_unlock(philo->right_fork);

        // SLEEPING
        log_state(philo, SLEEPING);
        usleep(philo->rules->time_to_sleep * 1000);
    }
    return (NULL);
}
```

## ✨ Bonus Part (Processes & Semaphores)

- **Program Name**: `philo_bonus`
- **External Functions**: Includes `fork`, `kill`, `exit`, `waitpid`, and `sem_*` functions.
- **Description**: Each philosopher is a separate process created with `fork()`. Forks are managed collectively by a single semaphore.

### Implementation Details
- The main process forks a child process for each philosopher.
- A named semaphore is initialized with the total number of forks (`number_of_philosophers`).
- To eat, a philosopher must call `sem_wait()` twice, effectively taking two forks from the central pile.
- After eating, they call `sem_post()` twice to return the forks.

```c
// Simplified bonus routine
void philosopher_process(t_philosopher *philo)
{
    while (1)
    {
        // THINKING
        log_state(philo, THINKING);

        // EATING
        sem_wait(philo->rules->forks_semaphore); // Take a fork
        log_state(philo, TOOK_FORK);
        sem_wait(philo->rules->forks_semaphore); // Take another fork
        log_state(philo, TOOK_FORK);

        log_state(philo, EATING);
        // ... eat ...

        sem_post(philo->rules->forks_semaphore); // Return a fork
        sem_post(philo->rules->forks_semaphore); // Return another fork

        // SLEEPING
        log_state(philo, SLEEPING);
        // ... sleep ...
    }
}
```

## 🧪 Testing Strategy

Testing for concurrency issues requires more than just checking output.

1.  **Data Race Detection**: Compile with the `-fsanitize=thread` flag and run the program. This sanitizer will report any data races at runtime.
    ```bash
    # Add to Makefile CFLAGS
    SANITIZE_FLAGS = -fsanitize=thread -g
    
    # Re-compile with the flags and run
    make re
    ./philo 4 410 200 200
    ```

2.  **Deadlock and Starvation Testing**: Run the simulation with stressful values and for a long duration.
    - **Low `time_to_die`**: `philo 4 210 200 200` (A philosopher might die if they wait too long).
    - **High number of philosophers**: `philo 200 500 200 200` (Tests efficiency).
    - **Long run**: Run without the optional `must_eat` argument and observe for several minutes to ensure it doesn't freeze.

3.  **Memory Leak Detection**: Use `valgrind` to ensure all allocated memory is freed.
    ```bash
    valgrind ./philo 5 800 200 200 7
    ```

## 🏗️ Project Structure

```
philosophers/
├── philo/
│   ├── src/
│   │   ├── main.c             # Entry point, argument parsing, thread creation
│   │   ├── routine.c          # The philosopher's main logic loop
│   │   ├── time.c             # Time management functions
│   │   ├── init.c             # Initialization of structs and mutexes
│   │   └── monitor.c          # Health-checking monitor thread
│   ├── includes/
│   │   └── philo.h            # Header with all structures and prototypes
│   └── Makefile
└── philo_bonus/
    ├── ... (similar structure for bonus)
```

## ✍️ Author

**Caroline Bahia**
- GitHub: [@carolinecbahia](https://github.com/carolinecbahia)
- 42 Login: `ccavalca`