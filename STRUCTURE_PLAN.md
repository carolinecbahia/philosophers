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
└── src/                      [MANDATORY - COMPLETO ✅]
    ├── main.c                (3 funções - main, init_program, main_loop) ✅
    ├── utils.c               (4 funções - validate, parser, init_table, init_philo) ✅
    ├── cleanup_and_error.c   (4 funções - error handling e cleanup) ✅
    ├── time.c                (3 funções - get_time_ms, get_elapsed_time_ms, ft_usleep) ✅
    ├── output.c              (2 funções - print_status, print_death) ✅
    ├── philosopher.c         (3 funções - philo_routine, take_forks, drop_forks) ✅
    ├── routines.c            (3 funções - philo_eat, philo_sleep, philo_think) ✅
    └── monitor.c             (2 funções - monitor_routine, check_death) ✅

└── bonus/                    [BONUS - A IMPLEMENTAR 🔴]
    ├── includes/
    │   └── philosophers_bonus.h (header do bônus)
    └── src/
        └── main_bonus.c      (stub inicial)
```

---

## 🔍 DISTRIBUIÇÃO DETALHADA DE FUNÇÕES

### **📄 types.h** (STRUCTS E ENUMS - IMPLEMENTADO ✅)
```c
typedef struct s_philo
{
    int             id;
    pthread_t       thread;
    pthread_mutex_t *fork_left;
    pthread_mutex_t *fork_right;
    long            last_meal;
}   t_philo;

typedef struct s_table
{
    int             num_philos;
    long            time_to_die;
    long            time_to_eat;
    long            time_to_sleep;
    long            start;
    int             min_meals;
    int             simulation;
    pthread_mutex_t *forks;
    pthread_mutex_t print_mutex;
    t_philo         *philo;
}   t_table;

typedef enum s_state
{
    EATING,
    THINKING,
    SLEEPING
}   t_state;
```

---

### **📄 philosophers.h** (MAIN HEADER - COMPLETO ✅)
```c
#ifndef PHILOSOPHERS_H
# define PHILOSOPHERS_H

/* Includes */
#include "types.h"
#include "libft.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <pthread.h>

/* Defines */
# define SUCCESS 0
# define FAILURE -1
# define TRUE 1
# define FALSE 0

/* ========== Main ========== */
int     main(int argc, char **argv);

/* ========== philosopher.c (A IMPLEMENTAR) ========== */
void    *philo_routine(void *arg);
void    take_forks(t_philo *philo, t_table *table);
void    drop_forks(t_philo *philo);

/* ========== routines.c (A IMPLEMENTAR) ========== */
void    philo_eat(t_philo *philo, t_table *table);
void    philo_sleep(t_table *table);
void    philo_think(void);

/* ========== monitor.c (A IMPLEMENTAR) ========== */
void    *monitor_routine(void *arg);
int     check_death(t_table *table);
int     check_all_ate(t_table *table);

/* ========== output.c (IMPLEMENTADO ✅) ========== */
void    print_status(t_table *table, int philo_id, char *status);
void    print_death(t_table *table, int philo_id);

/* ========== time.c (IMPLEMENTADO ✅) ========== */
long    get_time_ms(void);
long    get_elapsed_time_ms(long s_time);
int     ft_usleep(long msecs);

/* ========== utils.c (IMPLEMENTADO ✅) ========== */
int     validate_args(int ac, char **av);
int     parser(int ac, char **av, t_table *table);
int     init_table(t_table *table);

/* ========== cleanup_and_error.c (IMPLEMENTADO ✅) ========== */
void    return_error(char *error_msg);
void    cleanup(t_table *table);
void    destroy_mutexes(t_table *table);
void    error_exit(char *error_msg);

#endif
```

---

## 📝 DETALHAMENTO: O QUE VAI EM CADA ARQUIVO

### 🟢 **main.c** (1 função - IMPLEMENTADO ✅)

```c
┌─────────────────────────────────────────┐
│ 1. int main(int argc, char **argv)      │
│    - Valida argumentos                  │
│    - Inicializa table                   │
│    - Chama parser                       │
│    - Cleanup                            │
│    - Return status                      │
│                                         │
│    Linhas: ~20                          │
│    Calls: validate_args()               │
│           init_table()                  │
│           parser()                      │
│           error_exit()                  │
│           cleanup()                     │
└─────────────────────────────────────────┘

```

---

### 🟢 **utils.c** (4 funções - IMPLEMENTADO ✅)

```c
┌──────────────────────────────────────────────────┐
│ 1. int validate_args(int ac, char **av)         │
│    - Verificar se ac == 5                       │
│    - Verificar se são números válidos           │
│    - Usa ft_atoi_safe() para validação         │
│    - Retornar 1 se erro, 0 se ok               │
│    Linhas: ~20                                  │
│    Status: ✅ IMPLEMENTADO                      │
│                                                 │
│ 2. int parser(int ac, char **av,               │
│              t_table *table)                    │
│    - Converter strings para long                │
│    - Preencher struct table                     │
│    - ft_atoi() para conversão                  │
│    Linhas: ~10                                  │
│    Status: ✅ IMPLEMENTADO                      │
│                                                 │
│ 3. static int init_philo(t_table *table)       │
│    - Inicializa cada filósofo                  │
│    - Atribui IDs (1 a N)                       │
│    - Associa garfos esquerdo/direito           │
│    - Inicializa last_meal                      │
│    Linhas: ~15                                  │
│    Status: ✅ IMPLEMENTADO                      │
│                                                 │
│ 4. int init_table(t_table *table)              │
│    - Malloc para philos, forks                 │
│    - Inicializar mutexes                       │
│    - Chama init_philo()                        │
│    - Retornar 1 se erro, 0 se ok              │
│    Linhas: ~25                                  │
│    Status: ✅ IMPLEMENTADO                      │
└──────────────────────────────────────────────────┘
```

---

### � **cleanup_and_error.c** (4 funções - IMPLEMENTADO ✅)

```c
┌──────────────────────────────────────────────────┐
│ 1. void return_error(char *error_msg)           │
│    - Imprime mensagem de erro                   │
│    - Retorna 1                                  │
│    Linhas: ~5                                   │
│    Status: ✅ IMPLEMENTADO                      │
│                                                 │
│ 2. void cleanup(t_table *table)                 │
│    - Destrói mutexes de forks                  │
│    - Free forks array                          │
│    - Free philo array                          │
│    - Destrói print_mutex                       │
│    - Free table                                │
│    Linhas: ~20                                  │
│    Status: ✅ IMPLEMENTADO                      │
│                                                 │
│ 3. void destroy_mutexes(t_table *table)         │
│    - Loop: pthread_mutex_destroy() cada fork   │
│    - pthread_mutex_destroy() print_mutex       │
│    Linhas: ~12                                  │
│    Status: ✅ IMPLEMENTADO                      │
│                                                 │
│ 4. void error_exit(char *error_msg)             │
│    - Imprime mensagem de erro com ft_printf    │
│    - Retorna 1                                 │
│    Linhas: ~5                                   │
│    Status: ✅ IMPLEMENTADO                      │
└──────────────────────────────────────────────────┘
```

---

### 🟢 **philosopher.c** (AGUARDANDO IMPLEMENTAÇÃO 🔴)

```c
┌─────────────────────────────────────────────────┐
│ Status: 🔴 VAZIO (3 funções)                     │
│                                                 │
│ Funções a implementar:                          │
│ 1. void *philo_routine(void *arg)               │
│    - Rotina principal da thread do filósofo    │
│    - Loop: pensar → pegar garfos → comer →     │
│      soltar garfos → dormir                    │
│    - Verifica flag simulation para continuar   │
│    - Chama funções de routines.c               │
│    Linhas: ~20-25                               │
│                                                 │
│ 2. void take_forks(t_philo *philo,              │
│                    t_table *table)              │
│    - Pegar garfos esquerdo e direito           │
│    - pthread_mutex_lock() em cada garfo        │
│    - Imprimir status "has taken a fork"        │
│    - Tratar caso especial: 1 filósofo          │
│    Linhas: ~10-15                               │
│                                                 │
│ 3. void drop_forks(t_philo *philo)              │
│    - Soltar ambos os garfos                    │
│    - pthread_mutex_unlock() em cada garfo      │
│    Linhas: ~5                                   │
└─────────────────────────────────────────────────┘
```

---

### 🟢 **routines.c** (AGUARDANDO IMPLEMENTAÇÃO 🔴)

```c
┌─────────────────────────────────────────────────┐
│ Status: 🔴 VAZIO (3 funções)                     │
│                                                 │
│ Funções a implementar:                          │
│ 1. void philo_eat(t_philo *philo,               │
│                   t_table *table)               │
│    - Atualizar last_meal                       │
│    - Imprimir status "is eating"               │
│    - ft_usleep(time_to_eat)                    │
│    Linhas: ~8-10                                │
│                                                 │
│ 2. void philo_sleep(t_table *table)             │
│    - Imprimir status "is sleeping"             │
│    - ft_usleep(time_to_sleep)                  │
│    Linhas: ~5                                   │
│                                                 │
│ 3. void philo_think(void)                       │
│    - Imprimir status "is thinking"             │
│    - Apenas print, sem sleep                   │
│    Linhas: ~3-5                                 │
└─────────────────────────────────────────────────┘
```

---

### 🟢 **monitor.c** (AGUARDANDO IMPLEMENTAÇÃO 🔴)
│    - Thread de monitoramento principal         │
│    - Loop verificando check_death()            │
│    - Verifica check_all_ate() se min_meals > 0 │
│    - Para simulation quando detecta condição   │
│    Linhas: ~15-20                               │
│                                                 │
│ 2. int check_death(t_table *table)              │
│    - Loop por todos os filósofos               │
│    - Verifica tempo desde last_meal            │
│    - Se > time_to_die, imprime morte           │
│    - Retorna 1 se alguém morreu, 0 caso OK     │
│    Linhas: ~15                                  │
│                                                 │
│ 3. int check_all_ate(t_table *table)            │
│    - Verifica se todos comeram min_meals       │
│    - Retorna 1 se todos comeram, 0 caso não    │
│    Linhas: ~10                                   │
└──────────────────────────────────────────────────┘
```

---

### 🟢 **output.c** (IMPLEMENTADO ✅)

```c
┌──────────────────────────────────────────────┐
│ Status: ✅ IMPLEMENTADO                       │
│                                              │
│ 1. void print_status(t_table *table,        │
│                      int philo_id,          │
│                      char *status)          │
│    - pthread_mutex_lock(&print_mutex)      │
│    - Verifica simulation == 0 (se morreu)  │
│    - Calcula timestamp elapsed desde start │
│    - printf("%ld %d %s\n")                 │
│    - pthread_mutex_unlock(&print_mutex)    │
│    Linhas: ~14                              │
│    Status: ✅ IMPLEMENTADO                  │
│                                              │
│ 2. void print_death(t_table *table,         │
│                     int philo_id)           │
│    - Calcula timestamp elapsed             │
│    - pthread_mutex_lock(&print_mutex)      │
│    - Seta simulation = 0 (fecha porta)     │
│    - printf("%ld %d died\n")               │
│    - pthread_mutex_unlock(&print_mutex)    │
│    Linhas: ~10                              │
│    Status: ✅ IMPLEMENTADO                  │
└──────────────────────────────────────────────┘                  

### 🟢 **monitor.c** (AGUARDANDO IMPLEMENTAÇÃO 🔴)

```c
┌─────────────────────────────────────────────────┐
│ Status: 🔴 VAZIO (3 funções)                     │
│                                                 │
│ Funções a implementar:                          │
│ 1. void *monitor_routine(void *arg)             │
│    - Thread de monitoramento principal         │
│    - Loop verificando check_death()            │
│    - Verifica check_all_ate() se min_meals > 0 │
│    - Para simulation quando detecta condição   │
│    Linhas: ~15-20                               │
│                                                 │
│ 2. int check_death(t_table *table)              │
│    - Loop por todos os filósofos               │
│    - Verifica tempo desde last_meal            │
│    - Se > time_to_die, imprime morte           │
│    - Retorna 1 se alguém morreu, 0 caso OK     │
│    Linhas: ~15                                  │
│                                                 │
│ 3. int check_all_ate(t_table *table)            │
│    - Verifica se todos comeram min_meals       │
│    - Retorna 1 se todos comeram, 0 caso não    │
│    Linhas: ~10                                   │
└─────────────────────────────────────────────────┘
```

---

### 🟢 **output.c** (IMPLEMENTADO ✅)

```c
┌──────────────────────────────────────────────┐
│ Status: ✅ IMPLEMENTADO                      │
│                                              │
│ 1. void print_status(t_table *table,        │
│                      int philo_id,          │
│                      char *status)          │
│    - pthread_mutex_lock(&print_mutex)      │
│    - Verifica simulation flag dentro mutex │
│    - Calcula timestamp elapsed desde start │
│    - printf("%ld %d %s\n")                  │
│    - pthread_mutex_unlock(&print_mutex)    │
│    Linhas: ~14                              │
│    Status: ✅ IMPLEMENTADO                  │
│                                              │
│ 2. void print_death(t_table *table,         │
│                     int philo_id)           │
│    - Calcula timestamp elapsed             │
│    - pthread_mutex_lock(&print_mutex)      │
│    - Seta simulation = 0 (fecha porta)     │
│    - printf("%ld %d died\n")                │
│    - pthread_mutex_unlock(&print_mutex)    │
│    Linhas: ~10                              │
│    Status: ✅ IMPLEMENTADO                  │
└──────────────────────────────────────────────┘
```

---

### 🟢 **time.c** (IMPLEMENTADO ✅)

```c
┌──────────────────────────────────────────────┐
│ Status: ✅ IMPLEMENTADO                       │
│                                              │
│ 1. long get_time_ms(void)                    │
│    - Retorna tempo atual em milissegundos   │
│    - Usa gettimeofday()                     │
│    - Converte tv_sec e tv_usec para ms     │
│    Linhas: ~10                               │
│    Status: ✅ IMPLEMENTADO                   │
│                                              │
│ 2. long get_elapsed_time_ms(long s_time)    │
│    - Calcula tempo decorrido desde s_time   │
│    - Retorna diferença em milissegundos     │
│    Linhas: ~5                                │
│    Status: ✅ IMPLEMENTADO                   │
│                                              │
│ 3. int ft_usleep(long msecs)                 │
│    - Sleep preciso em milissegundos         │
│    - Loop com verificação constante         │
│    - Usa usleep(100) para precisão         │
│    Linhas: ~15                               │
│    Status: ✅ IMPLEMENTADO                   │
└──────────────────────────────────────────────┘
```

---

## 📋 CHECKLIST DE ORGANIZAÇÃO

### Arquivos Criados
- [x] `includes/types.h` - Estruturas ✅
- [x] `includes/ph (A IMPLEMENTAR)
  ├── philo_routine() → thread principal do filósofo
  ├── take_forks() → lock nos mutexes dos garfos
  ├── drop_forks() → unlock nos mutexes dos garfos
  ├── philo_eat() → atualiza last_meal, usa ft_usleep()
  ├── philo_sleep() → usa ft_usleep()
  ├── philo_think() → apenas imprime
  └── Usa: output.c (print_status), time.c (ft_usleep)

monitor.c (🔴 A IMPLEMENTAR)
  ├── monitor_routine() → thread de monitoramento
  ├── check_death() → verifica time_to_die
  ├── check_all_ate() → verifica min_meals
  └── Usa: output.c (print_death), time.c (get_time_ms)

output.c (🔴 A IMPLEMENTAR)
  ├── print_status() → imprime ações com timestamp
  ├── print_death() → imprime morte
  └── Usa: time.c (get_elapsed_time_ms), print_mutexmain.c, utils.c, cleanup_and_error.c, time.c
- ✅ **Implementados**: main.c, utils.c, cleanup_and_error.c, time.c, output.c
- 🔴 **Não iniciado**: philosopher.c, routines.c, monitor.c

---

## 🔗 DEPENDÊNCIAS ENTRE ARQUIVOS

```
main.c (✅ IMPLEMENTADO)
  ├── chama utils.c → validate_args(), parser(), init_table()
  ├── chama cleanup_and_error.c → error_exit(), cleanup()
  │
  └── (FUTURO) calls pthread_create() → philo_routine (philosopher.c)
                                     → monitor_routine (monitor.c)

utils.c (✅ IMPLEMENTADO)
  ├── validate_args() ✅
  ├── parser() ✅
  ├── init_philo() ✅
  └── init_table() ✅

cleanup_and_error.c (✅ IMPLEMENTADO)
  ├── return_error() ✅
  ├── cleanup() ✅
  ├── destroy_mutexes() ✅
  └── error_exit() ✅

time.c (✅ IMPLEMENTADO)
  ├── get_time_ms() ✅
  ├── get_elapsed_time_ms() ✅
  └── ft_usleep() ✅

philosopher.c (🔴 VAZIO)
  ├── philo_routine() → thread principal do filósofo
  ├── take_forks() → lock nos garfos
  ├── drop_forks() → unlock nos garfos
  ├── (FUTURO) chama routines.c → philo_eat(), philo_sleep(), philo_think()
  └── (FUTURO) usa output.c → print_status()

routines.c (🔴 VAZIO)
  ├── philo_eat() → atualiza last_meal, imprime, sleep
  ├── philo_sleep() → imprime status, ft_usleep
  ├── philo_think() → apenas imprime
  ├── Usa: output.c → print_status()
  └── Usa: time.c → ft_usleep(), get_time_ms()

monitor.c (🔴 VAZIO)
  ├── monitor_routine() → thread de monitoramento
  ├── check_death() → verifica time_to_die
  ├── check_all_ate() → verifica min_meals (bonus)
  ├── Usa: time.c → get_elapsed_time_ms()
  └── Usa: output.c → print_death()

output.c (✅ IMPLEMENTADO)
  ├── print_status() ✅
  ├── print_death() ✅
  └── Usa: time.c → get_elapsed_time_ms()

time.c (✅ IMPLEMENTADO)
  └── NÃO depende de nada do projeto (apenas syscalls)
```

---

## ✅ NORMA 42 COMPLIANCE

| Arquivo | Funções | Máx Linhas | Status |
|---------|---------|-----------|--------|
| main.c | 1 | ~20 | ✅ Implementado |
| utils.c | 4 | ~20 cada | ✅ Implementado |
| cleanup_and_error.c | 4 | ~20 cada | ✅ Implementado |
| time.c | 3 | ~15 cada | ✅ Implementado |
| output.c | 2 | ~14 cada | ✅ Implementado |
| philosopher.c | 3 | ~10-25 cada | 🔴 Vazio |
| routines.c | 3 | ~5-10 cada | 🔴 Vazio |
| monitor.c | 3 | ~10-20 cada | 🔴 Vazio |

**Total implementado: 12 funções em 4 arquivos**  
**Total planejado: ~20 funções em 7 arquivos**

---

## 🚀 ORDEM DE IMPLEMENTAÇÃO RECOMENDADA

```
✅ 1️⃣  types.h                 (estruturas base) - CONCLUÍDO
✅ 2️⃣  philosophers.h          (main header com tipos) - CONCLUÍDO
✅ 3️⃣  main.c                  (estrutura base) - CONCLUÍDO
✅ 4️⃣  cleanup_and_error.c     (cleanup/error) - CONCLUÍDO
✅ 5️⃣  utils.c                 (init/parser) - CONCLUÍDO
✅ 6️⃣  time.c                  (funções de tempo) - CONCLUÍDO
🔴✅ Headers completos (types.h, philosophers.h) - com todas as declarações
- ✅ Estrutura main.c funcionando - bugs corrigidos
- ✅ Sistema de cleanup e error handling completo
- ✅ Parsing e validação de argumentos completo
- ✅ Inicialização da mesa, filósofos e garfos completo
- ✅ Sistema de tempo completo (get_time_ms, get_elapsed_time_ms, ft_usleep)

### 🔴 Pendente (40%)
- 🔴 output.c - Sistema de logging (print_status, print_death)
- 🔴 philosopher.c - Lógica dos filósofos (6 funções)
- 🔴 monitor.c - Sistema de monitoramento (3 funções)

**Próximo Passo**: Implementar output.c (mais simples, usado por outros) → philosopher.c → monitor.c
### ⚠️ Variáveis Globais
- `pthread_mutex_t print_mutex` - Está dentro da struct `t_table` ✅
- Todos os dados compartilhados estão em `t_table` struct

### ⚠️ Struct Compartilhada
- `t_table *table` será passada por todos os threads
- Contém: config, mutex, philo array, forks array

### ⚠️ Race Conditions
- Usar mutex antes de acessar dados compartilhados
- `last_meal`, `simulation` precisam de proteção

### ⚠️ Diferenças na Implementação Atual
- Struct renomeada: `t_philosopher` → `t_philo`
- Campos renomeados: `left_fork/right_fork` → `fork_left/fork_right`
- Campo renomeado: `last_meal_time` → `last_meal`
- Campo renomeado: `target_meals` → `min_meals`
- Campo removido: `meals_eaten` (não está na struct atual)
- Campo adicionado: `simulation` (para controlar se simulação está rodando)
- Arquivo adicional: `cleanup_and_error.c` (separou cleanup de utils)

### ✅ Boas Práticas
- Cada arquivo tem responsabilidade clara
- Funções pequenas e testáveis
- Dependências bem definidas
- Fácil de debugar e manter
- Usando libft expandida com ft_printf e funções úteis

---

## � EDGE CASES - MANDATORY

### **Caso 1: Um Filósofo**

```bash
./philo 1 800 200 200
```

**Problema:**
- Filósofo tem `fork_left` e `fork_right` apontando para o **mesmo mutex**
- `fork_left = &forks[0]`
- `fork_right = &forks[(0 + 1) % 1]` = `&forks[0]`
- Quando tenta pegar 2 garfos, trava no segundo lock (deadlock)

**Comportamento esperado:**
- Filósofo pega 1 garfo
- Nunca consegue pegar o segundo (porque é o mesmo)
- Deve morrer após `time_to_die` ms
- Output: `"timestamp 1 has taken a fork"` → `"timestamp 1 died"`

**Solução possível:**
```c
// Em philosopher.c
if (table->num_philos == 1) {
    // Pegar apenas 1 garfo
    pthread_mutex_lock(philo->fork_left);
    print_status(table, philo->id, "has taken a fork");
    
    // Esperar time_to_die (sem comer)
    ft_usleep(table->time_to_die);
    
    // Não precisa fazer nada, monitor vai detectar morte
    pthread_mutex_unlock(philo->fork_left);
    return;
}
```

### **Caso 2: Validação de Tempos**

**Verificação implementada:**
```c
if (table->time_to_die < (table->time_to_eat + table->time_to_sleep))
```

**Motivo:** 
- Se tempo de morte < tempo para comer + dormir
- Filósofo nunca completa ciclo completo
- Morre inevitavelmente

**Exemplo:**
```bash
./philo 5 300 200 200  # 300 < 400 → Inválido!
```

### **Caso 3: Número Muito Grande de Filósofos**

**Consideração:**
- Sistema pode ter limite de threads/mutexes
- Testar com números grandes (100, 200, etc)
- Garantir que malloc e pthread_create não falham

**Tratamento:**
```c
// Verificar retorno de malloc e pthread_create
if (!table->forks || pthread_create(...) != 0) {
    // Cleanup e retornar erro
}
```

---

## 📊 RESUMO DO ESTADO ATUAL

### ✅ Implementado (87.5% - 7/8 arquivos)
- Headers completos (types.h, philosophers.h) - com todas as declarações ✅
- Estrutura main.c funcionando - bugs corrigidos ✅
- Sistema de cleanup e error handling completo ✅
- Parsing e validação de argumentos completo (4 args mandatory) ✅
- Validação de tempos (time_to_die >= time_to_eat + time_to_sleep) ✅
- Inicialização da mesa, filósofos e garfos completo ✅
- Sistema de tempo completo (get_time_ms, get_elapsed_time_ms, ft_usleep) ✅
- **output.c** - Sistema de logging (print_status, print_death) ✅
- **routines.c** - Ações dos filósofos (philo_eat, philo_sleep, philo_think) ✅
  - Campo `table` adicionado ao struct t_philo para acesso à mesa ✅
- **philosopher.c** - Lógica principal dos filósofos ✅
  - philo_routine: Loop completo implementado ✅
  - take_forks: Locks + edge case de 1 filósofo tratado ✅
  - drop_forks: Unlocks implementados ✅

### 🔴 Pendente (12.5% - 1/8 arquivos)
- **monitor.c** - 3 funções (monitor_routine, check_death, check_all_ate) 🔴
  - Todas vazias, aguardando implementação
  - Necessário para detecção de morte e finalização da simulação

### 🧪 Testes Realizados
**Teste 1: Validação Base (6 jan 2026) - ✅ SUCESSO**
- **Objetivo**: Validar threads, print_mutex, timestamps e routines
- **Método**: Versão simplificada SEM garfos (sem contenção)
- **Resultados**:
  - ✅ 5 threads criadas e rodando em paralelo
  - ✅ print_mutex funcionando (nenhuma mensagem sobreposta)
  - ✅ Timestamps corretos (incrementos de 200ms)
  - ✅ Ciclo completo think → eat → sleep validado
  - ✅ last_meal sendo atualizado corretamente
  - ✅ Todos comem simultaneamente (comportamento esperado sem garfos)
  - ✅ Encerramento gracioso após 5s (simulation flag)
  - ✅ Nenhum segfault ou memory leak visível
- **Conclusão**: Base 100% funcional, pronta para implementação de sincronização

**Teste 2: Pendente - COM Sincronização de Garfos**
- Após implementar monitor.c
- Validar contenção por recursos (garfos)
- Verificar deadlock prevention
- Testar edge case de 1 filósofo

### 📝 Nota sobre Bonus
- Campo `min_meals` existe na struct mas é **para BONUS**
- 5º argumento (number_of_times_must_eat) é **BONUS**
- No mandatory: simulação termina apenas quando alguém morre
- Implementar bonus **depois** do mandatory funcionando

### 📂 Status do Projeto

**MANDATORY - COMPLETO ✅** (6 de janeiro de 2026)
```
Total: 8 arquivos fonte
✅ Completos: 8 (main, utils, cleanup_and_error, time, output, routines, philosopher, monitor)
Progresso: 100% ████████████████████████
```

**Testes realizados:**
- ✅ 1 filósofo (800ms) → morre corretamente em ~801ms
- ✅ 5 filósofos (800ms) → simulação indefinida sem mortes
- ✅ Valgrind → zero leaks
- ✅ Data race em last_meal → corrigido com mutex

**Correções aplicadas:**
1. Segfault no parser → removido acesso a philo não-alocado
2. Inicialização last_meal → table->start no init_philo
3. Data race last_meal → protegido com print_mutex

---

## 🎁 BONUS - COMPLETO ✅ (6 de janeiro de 2026)

**Status:** 100% implementado e testado!

**Estratégia implementada:** Reutilização máxima sem duplicação
- ✅ Header wrapper: `bonus/includes/philosophers.h` → redireciona para `philosophers_bonus.h`
- ✅ Arquivos modificados: 4 em `bonus/src/` (main, utils, routines, monitor)
- ✅ Arquivos reutilizados: 4 de `src/` (philosopher, output, time, cleanup)
- ✅ Makefile com `CFLAGS_BONUS` para compilar com includes corretos

**Diferenças do Mandatory:**
1. **5º argumento (opcional)**: `number_of_times_each_philosopher_must_eat`
2. **Condição de parada adicional**: Todos comeram X vezes OU alguém morreu
3. **Nova função**: `check_all_ate()` no monitor_bonus.c
4. **Novo campo**: `int meals_eaten` em t_philo (types_bonus.h)
5. **Proteção com mutex**: `meals_eaten++` protegido por print_mutex

**Arquivos implementados:**
```
bonus/
├── includes/
│   ├── philosophers.h        ✅ (wrapper → philosophers_bonus.h)
│   ├── philosophers_bonus.h  ✅ (declarações completas)
│   └── types_bonus.h         ✅ (structs com meals_eaten)
└── src/
    ├── main_bonus.c          ✅ (argc == 5 ou 6)
    ├── utils_bonus.c         ✅ (parser + init_table + init_philo)
    ├── routines_bonus.c      ✅ (3 funções: eat/sleep/think)
    └── monitor_bonus.c       ✅ (3 funções: routine/check_death/check_all_ate)
```

**Arquivos reutilizados (compilados com -I./bonus/includes):**
- `src/philosopher.c` → philo_routine, take_forks, drop_forks
- `src/output.c` → print_status, print_death
- `src/time.c` → get_time_ms, get_elapsed_time_ms, ft_usleep
- `src/cleanup_and_error.c` → cleanup, destroy_mutexes, error_exit

**Testes realizados:**
- ✅ `./philo_bonus 2 800 200 200 2` → para quando ambos comem 2x
- ✅ `./philo_bonus 5 800 200 200 3` → para quando todos comem 3x
- ✅ Sem 5º argumento → comportamento idêntico ao mandatory (roda infinito)
- ✅ Zero leaks (reutiliza cleanup do mandatory)

**Funcionamento:**
- `check_all_ate()` verifica se todos os filósofos atingiram `min_meals`
- `meals_eaten` é incrementado em `philo_eat()` (protegido por mutex)
- Monitor chama `check_death() || check_all_ate()` a cada 1ms
- Quando `check_all_ate()` retorna 1 → `simulation = 0` → threads terminam

---

**Última atualização**: 6 de janeiro de 2026 (após mandatory completo)
