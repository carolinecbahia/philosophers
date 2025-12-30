# 🏗️ Plano de Organização - Philosophers

**Objetivo**: Distribuir funções nos arquivos respeitando Norma 42 (máx 5 funções/arquivo, máx 25 linhas/função)

---

## 📊 MAPA VISUAL DE ARQUIVOS E FUNÇÕES

```
philosophers/
│
├── includes/
│   ├── philosophers.h         (Main header - declarações)
│   └── types.h               (Estruturas e tipos)
│
└── src/
    ├── main.c                (2-3 funções)
    ├── utils.c               (5 funções)
    ├── philosopher.c         (3 funções)
    ├── monitor.c             (2 funções)
    ├── output.c              (2 funções)
    └── time.c                (2 funções)
```

---

## 🔍 DISTRIBUIÇÃO DETALHADA DE FUNÇÕES

### **📄 types.h** (APENAS STRUCTS E ENUMS)
```
typedef enum s_state {
    THINKING,
    EATING,
    SLEEPING
}   t_state;

typedef struct s_philosopher {
    int             id;
    pthread_t       thread;
    pthread_mutex_t *left_fork;
    pthread_mutex_t *right_fork;
    long            last_meal_time;
    int             meals_eaten;
}   t_philosopher;

typedef struct s_table {
    int             num_philosophers;
    long            time_to_die;
    long            time_to_eat;
    long            time_to_sleep;
    int             target_meals;
    int             all_ate_enough;
    long            start_time;
    pthread_t       monitor_thread;
    t_philosopher   *philosophers;
    pthread_mutex_t *forks;
    pthread_mutex_t print_mutex;
}   t_table;
```

---

### **📄 philosophers.h** (MAIN HEADER)
```c
#ifndef PHILOSOPHERS_H
# define PHILOSOPHERS_H

/* Includes */
#include "types.h"
#include <pthread.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declarações de Funções Públicas */

/* ========== main.c ========== */
int     main(int ac, char **av);

/* ========== utils.c ========== */
int     validate_args(int ac, char **av);
int     parse_arguments(int ac, char **av, t_table *table);
int     init_philosophers(t_table *table);
void    cleanup(t_table *table);
void    destroy_mutexes(t_table *table);

/* ========== philosopher.c ========== */
void    *philo_routine(void *arg);
int     take_forks(t_philosopher *philo, t_table *table);
void    put_forks(t_philosopher *philo);

/* ========== monitor.c ========== */
void    *monitor_routine(void *arg);
int     check_death(t_table *table);

/* ========== output.c ========== */
void    safe_print(t_table *table, int id, const char *action);
void    print_death(t_table *table, int id);

/* ========== time.c ========== */
long    get_time_ms(void);
int     ft_usleep(long milliseconds);

#endif
```

---

## 📝 DETALHAMENTO: O QUE VAI EM CADA ARQUIVO

### 🟢 **main.c** (2 funções)

```c
┌─────────────────────────────────────────┐
│ 1. int main(int ac, char **av)          │
│    - Parse args                         │
│    - Initialize table                   │
│    - Create philosopher threads         │
│    - Create monitor thread              │
│    - Join threads                       │
│    - Cleanup                            │
│    - Return status                      │
│                                         │
│    Linhas: ~20                          │
│    Calls: parse_arguments()             │
│            init_philosophers()          │
│            pthread_create()             │
│            pthread_join()               │
│            cleanup()                    │
└─────────────────────────────────────────┘

```

---

### 🟢 **utils.c** (5 funções - MÁXIMO)

```c
┌──────────────────────────────────────────────────┐
│ 1. int validate_args(int ac, char **av)         │
│    - Verificar se ac == 4 ou 5                 │
│    - Verificar se são números válidos          │
│    - Retornar 1 se ok, 0 se erro              │
│    Linhas: ~15                                 │
│                                                │
│ 2. int parse_arguments(int ac, char **av,      │
│                        t_table *table)         │
│    - Converter strings para long               │
│    - Preencher struct table                    │
│    - Validar valores (não negativos)          │
│    - Inicializar campos                        │
│    Linhas: ~18                                 │
│                                                │
│ 3. int init_philosophers(t_table *table)       │
│    - Malloc arrays de forks e philosophers    │
│    - Inicializar mutexes de forks             │
│    - Preencher struct philosopher (id, etc)   │
│    - Retornar status                          │
│    Linhas: ~20                                 │
│                                                │
│ 4. void cleanup(t_table *table)                │
│    - Chamar destroy_mutexes()                  │
│    - Free philosophers                        │
│    - Free forks array                         │
│    Linhas: ~10                                 │
│                                                │
│ 5. void destroy_mutexes(t_table *table)        │
│    - Loop: pthread_mutex_destroy() cada fork  │
│    - pthread_mutex_destroy() print_mutex      │
│    Linhas: ~10                                 │
└──────────────────────────────────────────────────┘
```

---

### 🟢 **philosopher.c** (3 funções)

```c
┌─────────────────────────────────────────────────┐
│ 1. void *philo_routine(void *arg)               │
│    - Cast arg para t_philosopher*              │
│    - Loop while simulation running:            │
│      - Pensar                                  │
│      - Tomar garfos                            │
│      - Comer                                   │
│      - Soltar garfos                           │
│      - Dormir                                  │
│    Linhas: ~20                                 │
│    Calls: take_forks()                         │
│            safe_print()                        │
│            ft_usleep()                         │
│            put_forks()                         │
│                                                │
│ 2. int take_forks(t_philosopher *philo,        │
│                   t_table *table)              │
│    - pthread_mutex_lock() left_fork           │
│    - safe_print() "has taken fork"             │
│    - pthread_mutex_lock() right_fork          │
│    - safe_print() "has taken fork"             │
│    - Atualizar last_meal_time                  │
│    Linhas: ~15                                 │
│                                                │
│ 3. void put_forks(t_philosopher *philo)        │
│    - pthread_mutex_unlock() right_fork        │
│    - pthread_mutex_unlock() left_fork         │
│    Linhas: ~5                                  │
└─────────────────────────────────────────────────┘
```

---

### 🟢 **monitor.c** (2 funções)

```c
┌─────────────────────────────────────────────────┐
│ 1. void *monitor_routine(void *arg)             │
│    - Cast arg para t_table*                    │
│    - Loop while check_death() == 0:            │
│      - ft_usleep(1) - check frequente         │
│    - Retornar NULL                             │
│    Linhas: ~10                                 │
│    Calls: check_death()                        │
│            ft_usleep()                         │
│                                                │
│ 2. int check_death(t_table *table)             │
│    - Loop por cada filósofo                    │
│    - Calcular tempo desde última refeição      │
│    - Se > time_to_die:                         │
│      - print_death()                           │
│      - Retornar 1 (MORTE DETECTADA)           │
│    - Se todos comeram target meals:            │
│      - Retornar 1 (SIMULAÇÃO COMPLETA)        │
│    - Retornar 0 (continuar)                    │
│    Linhas: ~20                                 │
│    Calls: get_time_ms()                        │
│            print_death()                       │
└─────────────────────────────────────────────────┘
```

---

### 🟢 **output.c** (2 funções)

```c
┌──────────────────────────────────────────────┐
│ 1. void safe_print(t_table *table,            │
│                    int id,                    │
│                    const char *action)        │
│    - pthread_mutex_lock(&print_mutex)         │
│    - Calcular timestamp                       │
│    - printf("%ld %d %s\n", ...)              │
│    - fflush(stdout)                           │
│    - pthread_mutex_unlock(&print_mutex)       │
│    Linhas: ~12                                │
│    Calls: get_time_ms()                       │
│                                               │
│ 2. void print_death(t_table *table, int id)  │
│    - Chamar safe_print()                      │
│    - Com action: "died"                       │
│    Linhas: ~5                                 │
│    Calls: safe_print()                        │
└──────────────────────────────────────────────┘
```

---

### 🟢 **time.c** (2 funções)

```c
┌──────────────────────────────────────────────┐
│ 1. long get_time_ms(void)                     │
│    - struct timeval time                      │
│    - gettimeofday(&time, NULL)               │
│    - Retornar (time.tv_sec * 1000) +         │
│             (time.tv_usec / 1000)            │
│    Linhas: ~8                                 │
│                                               │
│ 2. int ft_usleep(long milliseconds)           │
│    - Converter ms para struct timespec        │
│    - nanosleep() ou loop de usleep           │
│    - Retornar 0 se ok                         │
│    Linhas: ~15                                │
└──────────────────────────────────────────────┘
```

---

## 📋 CHECKLIST DE ORGANIZAÇÃO

### Arquivos a Criar
- [ ] `includes/types.h` - Estruturas
- [ ] `src/utils.c` - Inicialização/cleanup
- [ ] `src/philosopher.c` - Rotina do filósofo
- [ ] `src/monitor.c` - Monitor de morte
- [ ] `src/output.c` - Logging
- [ ] `src/time.c` - Funções de tempo

### Headers a Atualizar
- [ ] `includes/philosophers.h` - Incluir types.h, declarar todas as funções

### Main.c
- [ ] Limpar (está vazio)
- [ ] Implementar função main

### Makefile
- [ ] Verificar se lista todos os .c files
- [ ] Adicionar novos arquivos .c

---

## 🔗 DEPENDÊNCIAS ENTRE ARQUIVOS

```
main.c
  ├── includes utils.c → validate_args(), parse_arguments(), 
  │                      init_philosophers(), cleanup()
  │
  ├── calls pthread_create() → philo_routine (philosopher.c)
  │
  └── calls pthread_create() → monitor_routine (monitor.c)

philosopher.c
  ├── includes output.c → safe_print()
  ├── includes time.c → get_time_ms(), ft_usleep()
  └── calls utils.c → take_forks(), put_forks()

monitor.c
  ├── includes time.c → get_time_ms(), ft_usleep()
  └── includes output.c → print_death()

output.c
  └── includes time.c → get_time_ms()

time.c
  └── NÃO depende de nada do projeto (apenas syscalls)
```

---

## ✅ NORMA 42 COMPLIANCE

| Arquivo | Funções | Máx Linhas | Status |
|---------|---------|-----------|--------|
| main.c | 1 | 20 | ✅ |
| utils.c | 5 | 20 cada | ✅ (máximo permitido) |
| philosopher.c | 3 | 20 cada | ✅ |
| monitor.c | 2 | 20 cada | ✅ |
| output.c | 2 | 15 cada | ✅ |
| time.c | 2 | 15 cada | ✅ |

**Total: 15 funções em 6 arquivos**

---

## 🚀 ORDEM DE IMPLEMENTAÇÃO RECOMENDADA

```
1️⃣  types.h                 (estruturas base)
2️⃣  time.c                  (independente)
3️⃣  philosophers.h          (main header com tipos)
4️⃣  utils.c                 (init/cleanup)
5️⃣  output.c                (logging)
6️⃣  philosopher.c           (lógica filósofo)
7️⃣  monitor.c               (monitor morte)
8️⃣  main.c                  (orchestração final)
9️⃣  Makefile                (update se necessário)
```

---

## 📌 NOTAS IMPORTANTES

### ⚠️ Variáveis Globais (EXCEÇÃO PERMITIDA)
- `pthread_mutex_t print_mutex` - PODE ser global para sincronização
- Mas melhor: passar via `t_table` struct

### ⚠️ Struct Compartilhada
- `t_table *table` será passada por todos os threads
- Contém: config, mutex, philosophers array, forks array

### ⚠️ Race Conditions
- Usar mutex antes de acessar dados compartilhados
- `last_meal_time`, `all_ate_enough` precisam de proteção

### ✅ Boas Práticas
- Cada arquivo tem responsabilidade clara
- Funções pequenas e testáveis
- Dependências bem definidas
- Fácil de debugar e manter

---

**Próximo Passo**: Criar arquivos seguindo este plano! 🎯
