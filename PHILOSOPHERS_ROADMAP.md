# 📚 Philosophers - Roadmap de Conceitos Detalhado

**Objetivo**: Dominar programação multi-thread em C para implementar o problema dos Filósofos.

**Nível**: Intermediário/Avançado  
**Duração estimada**: 3-4 semanas  
**Prerequisitos**: C intermediário, estruturas de dados básicas

---

## **1. FUNDAMENTOS DE CONCORRÊNCIA**

### O que é Concorrência?
Concorrência é a execução de múltiplas tarefas que parecem acontecer ao mesmo tempo. Em sistemas modernos com múltiplos cores, isso é **paralelismo real**.

### Processos vs Threads

#### **Processos**
- Espaço de memória isolado
- PID único
- Comunicação via IPC (Inter-Process Communication)
- Mais pesado em recursos
- Mais seguro (isolamento de memória)

```c
// Criar novo processo
pid_t pid = fork();
if (pid == 0) {
    // Código executado no processo filho
} else {
    // Código executado no processo pai
}
```

#### **Threads**
- Compartilham o mesmo espaço de memória
- TID (Thread ID)
- Comunicação via memória compartilhada
- Mais leve em recursos
- Requer sincronização cuidadosa

```c
// Criar nova thread
pthread_t thread;
pthread_create(&thread, NULL, funcao_thread, arg);
```

### Race Conditions
**Problema**: Duas threads acessam/modificam a mesma variável simultaneamente

```c
// PERIGO: Race condition
int contador = 0;

// Thread 1
contador++;  // Lê contador, incrementa, escreve

// Thread 2
contador++;  // Lê contador, incrementa, escreve

// Esperado: 2
// Realidade: Pode ser 1 (ambas lêem 0, incrementam, escrevem 1)
```

**Solução**: Usar mutexes para proteção

### Deadlock (Impasse)
**Problema**: Threads ficam esperando uma pela outra indefinidamente

```
Thread A segura Lock1, espera por Lock2
Thread B segura Lock2, espera por Lock1
→ DEADLOCK INFINITO
```

**Condições para deadlock (todas precisam ser verdadeiras)**:
1. Exclusão mútua (recursos não são compartilháveis)
2. Hold and wait (thread segura recurso e espera outro)
3. Sem preempção (recursos não podem ser tomados)
4. Espera circular (ciclo de dependências)

### Starvation (Fome)
**Problema**: Uma thread nunca consegue acesso aos recursos que precisa

```
Thread A: Sempre consegue acesso primeiro
Thread B: Fica esperando indefinidamente
```

**Referências:**
- "Operating System Concepts" - Silberschatz, Galvin, Gagne - Cap. 4-5
- Linux man pages: `man pthread` (visão geral de threads POSIX)

---

## **2. SINCRONIZAÇÃO E MUTEXES**

### O que é um Mutex?

Mutex = **Mutual Exclusion Lock** (Fechadura de Exclusão Mútua)

Um mutex é como uma porta de banheiro:
- Apenas 1 pessoa por vez pode entrar
- Outras esperam na fila
- Após sair, a próxima pessoa entra

### Operações Básicas

#### **Inicialização**
```c
#include <pthread.h>

pthread_mutex_t mutex;

// Opção 1: Estático
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

// Opção 2: Dinâmico (recomendado para projeto)
pthread_mutex_init(&mutex, NULL);
```

#### **Lock (Adquirir)**
```c
// Bloqueante - espera se outro thread tem o lock
pthread_mutex_lock(&mutex);

// Não-bloqueante - retorna erro se já tem o lock
int ret = pthread_mutex_trylock(&mutex);
if (ret == 0) {
    // Conseguiu o lock
} else {
    // Outro thread tem o lock
}
```

#### **Unlock (Liberar)**
```c
pthread_mutex_unlock(&mutex);
```

#### **Destruição**
```c
pthread_mutex_destroy(&mutex);
```

### Seção Crítica (Critical Section)

```c
// Seção crítica: código que modifica dados compartilhados
pthread_mutex_lock(&mutex);

// Apenas 1 thread executa por vez
compartilhado_variavel++;
printf("Valor: %d\n", compartilhado_variavel);

pthread_mutex_unlock(&mutex);
```

### Tipos de Mutexes

```c
pthread_mutexattr_t attr;
pthread_mutexattr_init(&attr);

// Normal (default)
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);

// Recursive (mesma thread pode fazer lock múltiplas vezes)
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);

// Errorcheck (retorna erro se já está locked)
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK);

pthread_mutex_init(&mutex, &attr);
pthread_mutexattr_destroy(&attr);
```

### Padrão Seguro com Mutex

```c
// ✅ CORRETO
void incrementar_contador() {
    pthread_mutex_lock(&mutex);
    contador++;
    printf("Contador: %d\n", contador);
    pthread_mutex_unlock(&mutex);
}

// ❌ ERRADO: Pode vazar o lock se houver erro
void incrementar_contador_errado() {
    pthread_mutex_lock(&mutex);
    
    if (condicao_erro) {
        return; // LOCK NÃO FOI LIBERADO!
    }
    
    contador++;
    pthread_mutex_unlock(&mutex);
}

// ✅ MELHOR: Usar cleanup handler
void incrementar_contador_seguro() {
    pthread_mutex_lock(&mutex);
    pthread_cleanup_push((void(*)(void*))pthread_mutex_unlock, 
                         (void*)&mutex);
    
    // Código seguro aqui
    contador++;
    
    pthread_cleanup_pop(1); // 1 = executa handler
}
```

**Referências:**
- Linux man pages: `man pthread_mutex_init`
- Linux man pages: `man pthread_mutex_lock`
- "Programming with POSIX Threads" - David Butenhof

---

## **3. THREADS EM C (POSIX)**

### Criação de Threads

```c
#include <pthread.h>

// Função que a thread vai executar
void* thread_func(void* arg) {
    int* id = (int*)arg;
    printf("Thread ID: %d\n", *id);
    return NULL;
}

int main() {
    pthread_t thread;
    int thread_id = 42;
    
    // Criar thread
    int ret = pthread_create(&thread, NULL, thread_func, &thread_id);
    
    if (ret != 0) {
        perror("pthread_create failed");
        return 1;
    }
    
    // Main continua executando
    
    return 0;
}
```

### Joinagem (Esperando por Thread)

```c
// Esperar thread terminar
int ret = pthread_join(thread, NULL);

if (ret != 0) {
    perror("pthread_join failed");
}

// Agora thread terminou e seus recursos foram liberados
```

**Sem `pthread_join`**: Recurso de thread vira "zumbi"

### Detachamento de Threads

```c
// Deixar thread se limpar sozinha ao terminar
pthread_detach(thread);

// Ou definir atributo antes de criar
pthread_attr_t attr;
pthread_attr_init(&attr);
pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
pthread_create(&thread, &attr, thread_func, arg);
```

**Joinagem vs Detachamento:**
- **Join**: Thread pai espera; controle de sincronização
- **Detach**: Thread se limpa sozinha; não pode esperar

### Passando Múltiplos Argumentos

```c
// Estrutura para passar múltiplos dados
typedef struct {
    int id;
    char* nome;
    pthread_mutex_t* mutex;
} thread_args_t;

void* thread_func(void* arg) {
    thread_args_t* args = (thread_args_t*)arg;
    
    printf("ID: %d, Nome: %s\n", args->id, args->nome);
    
    free(args);  // Liberar memória alocada
    return NULL;
}

// Uso
thread_args_t* args = malloc(sizeof(thread_args_t));
args->id = 1;
args->nome = "Filosofo";
args->mutex = &meu_mutex;

pthread_create(&thread, NULL, thread_func, args);
```

### Exit de Threads

```c
// Thread termina e retorna valor
void* thread_func(void* arg) {
    int* resultado = malloc(sizeof(int));
    *resultado = 42;
    return resultado;
}

// Main
void* retorno;
pthread_join(thread, &retorno);

int* resultado = (int*)retorno;
printf("Resultado: %d\n", *resultado);
free(resultado);
```

### Atributos de Threads

```c
pthread_attr_t attr;
pthread_attr_init(&attr);

// Definir tamanho de stack
pthread_attr_setstacksize(&attr, 1024*1024); // 1MB

// Definir prioridade
int policy;
struct sched_param param;
pthread_attr_getschedpolicy(&attr, &policy);
param.sched_priority = 10;
pthread_attr_setschedparam(&attr, &param);

pthread_create(&thread, &attr, thread_func, arg);
pthread_attr_destroy(&attr);
```

**Referências:**
- Linux man pages: `man pthread_create`
- Linux man pages: `man pthread_join`
- POSIX.1-2017 standard (ISO/IEC/IEEE 9945-1)

---

## **4. O PROBLEMA DOS FILÓSOFOS**

### Contexto Histórico

Proposto por **Edsger Dijkstra** em 1965 como problema de exemplo para deadlock e sincronização.

**Versão Original**: "Problema do Jantar dos Filósofos"

### O Problema: Definição Formal

```
N filósofos sentam em volta de uma mesa redonda.
Entre cada dois filósofos, há 1 garfo.
Total: N filósofos, N garfos.

Cada filósofo tem 3 estados:
1. Pensando (não precisa de garfos)
2. Comendo (precisa de 2 garfos: esquerda e direita)
3. Esperando (tentando pegar garfos)

Restrições:
- Um garfo só pode ser usado por um filósofo por vez
- Um garfo é compartilhado entre 2 filósofos
- Cada filósofo precisa de ambos os garfos para comer
```

### Visualização

```
        Filósofo 0
          /   \
    Garfo0     Garfo1
    /              \
F4                  F1
|                    |
G3                  G2
\                   /
 \    Garfo2      /
  Filósofo 2 - Filósofo 3
```

### Estados e Transições

```
Pensando ─(pega garfos)─→ Comendo ─(solta garfos)─→ Pensando
                            ↑
                            │
                     Esperando (tentando pegar)
```

### Representação em C

```c
typedef enum {
    THINKING,
    EATING,
    SLEEPING
} t_state;

typedef struct {
    int id;
    t_state state;
    pthread_t thread;
    long last_meal;
} t_philosopher;

typedef struct {
    int num_philosophers;
    pthread_mutex_t* forks;  // Array de mutexes
    t_philosopher* philosophers;
    pthread_mutex_t state_mutex;  // Protege estado compartilhado
    long time_to_die;
    long time_to_eat;
    long time_to_sleep;
} t_table;
```

### O Problema Clássico: Deadlock

```c
// CÓDIGO QUE CAUSA DEADLOCK
void* philosopher_routine(void* arg) {
    t_philosopher* philo = (t_philosopher*)arg;
    int left_fork = philo->id;
    int right_fork = (philo->id + 1) % num_philosophers;
    
    while (1) {
        // PROBLEMA: Todos pegam garfo esquerdo
        pthread_mutex_lock(&forks[left_fork]);
        printf("Filósofo %d pegou garfo esquerdo\n", philo->id);
        
        usleep(100); // Simula pensamento
        
        // Nenhém consegue pegar garfo direito!
        // DEADLOCK
        pthread_mutex_lock(&forks[right_fork]);
        printf("Filósofo %d pegou garfo direito\n", philo->id);
        
        // ... comer ...
        
        pthread_mutex_unlock(&forks[right_fork]);
        pthread_mutex_unlock(&forks[left_fork]);
    }
    
    return NULL;
}
```

**Referências:**
- Dijkstra, E. W. "The Structure of the THE Multiprogramming System" (1968)
- "Operating System Concepts" - Cap. 7 (Deadlock)

---

## **5. ESTRATÉGIAS DE SOLUÇÃO**

### Solução 1: Ordem Simples de Garfos

```c
// Todos pegam sempre garfo esquerda primeiro, depois direita
// Mas evitando ordem cíclica
void* philosopher_routine(void* arg) {
    t_philosopher* philo = (t_philosopher*)arg;
    int left = philo->id;
    int right = (philo->id + 1) % num_philosophers;
    
    // Garantir ordem: sempre pega menor ID primeiro
    if (left > right) {
        int temp = left;
        left = right;
        right = temp;
    }
    
    while (1) {
        // Pensar
        think();
        
        // Pegar garfos em ordem determinística
        pthread_mutex_lock(&forks[left]);
        pthread_mutex_lock(&forks[right]);
        
        // Comer
        eat();
        
        // Liberar
        pthread_mutex_unlock(&forks[right]);
        pthread_mutex_unlock(&forks[left]);
    }
    
    return NULL;
}
```

**Vantagem**: Simples, evita deadlock  
**Desvantagem**: Ordem artificial, não elegante

### Solução 2: Garcom (Waiter)

```c
// Um mutex adicional controla quem pode tentar comer
pthread_mutex_t waiter;

void* philosopher_routine(void* arg) {
    t_philosopher* philo = (t_philosopher*)arg;
    int left = philo->id;
    int right = (philo->id + 1) % num_philosophers;
    
    while (1) {
        think();
        
        // Pedir ao garcom permissão
        pthread_mutex_lock(&waiter);
        {
            pthread_mutex_lock(&forks[left]);
            pthread_mutex_lock(&forks[right]);
        }
        pthread_mutex_unlock(&waiter);
        
        // Comer
        eat();
        
        // Liberar garfos
        pthread_mutex_unlock(&forks[right]);
        pthread_mutex_unlock(&forks[left]);
    }
    
    return NULL;
}
```

**Vantagem**: Elegante, fácil de entender  
**Desvantagem**: Menos paralelismo (garcom é gargalo)

### Solução 3: Estados (Chandy/Misra)

```c
typedef enum {
    THINKING,
    HUNGRY,
    EATING
} t_state;

pthread_mutex_t state_locks[5];
t_state philosopher_state[5];

void take_fork(int philosopher) {
    pthread_mutex_lock(&state_mutex);
    {
        philosopher_state[philosopher] = HUNGRY;
        test(philosopher);
    }
    pthread_mutex_unlock(&state_mutex);
    
    // Esperar estar em estado EATING
    while (philosopher_state[philosopher] != EATING) {
        usleep(100);
    }
}

void test(int philosopher) {
    int left = (philosopher + 4) % 5;
    int right = (philosopher + 1) % 5;
    
    if (philosopher_state[philosopher] == HUNGRY &&
        philosopher_state[left] != EATING &&
        philosopher_state[right] != EATING) {
        
        philosopher_state[philosopher] = EATING;
    }
}

void put_fork(int philosopher) {
    pthread_mutex_lock(&state_mutex);
    {
        philosopher_state[philosopher] = THINKING;
        
        // Tentar deixar vizinhos comerem
        test((philosopher + 4) % 5);
        test((philosopher + 1) % 5);
    }
    pthread_mutex_unlock(&state_mutex);
}
```

**Vantagem**: Máximo paralelismo, sem deadlock por design  
**Desvantagem**: Mais complexo

### Solução 4: Timeout

```c
void* philosopher_routine(void* arg) {
    t_philosopher* philo = (t_philosopher*)arg;
    int left = philo->id;
    int right = (philo->id + 1) % num_philosophers;
    
    while (1) {
        think();
        
        // Tentar pegar com timeout
        if (pthread_mutex_trylock(&forks[left]) == 0) {
            if (pthread_mutex_trylock(&forks[right]) == 0) {
                // Conseguiu ambos
                eat();
                pthread_mutex_unlock(&forks[right]);
            } else {
                // Falhou em pegar direita, soltar esquerda
                pthread_mutex_unlock(&forks[left]);
                usleep(100); // Esperar um pouco e tentar de novo
                continue;
            }
        } else {
            usleep(100); // Não conseguiu esquerda
            continue;
        }
        
        pthread_mutex_unlock(&forks[left]);
    }
    
    return NULL;
}
```

**Vantagem**: Simples, evita deadlock  
**Desvantagem**: Pode ter starvation

**Referências:**
- Dijkstra, E. W. "Hierarchical Ordering of Sequential Processes" (1971)
- Chandy, K. M., & Misra, J. "The Drinking Philosophers Problem" (1984)

---

## **6. TIMING E DELAYS**

### Medição de Tempo

```c
#include <sys/time.h>

long get_current_time_ms() {
    struct timeval time;
    gettimeofday(&time, NULL);
    return (time.tv_sec * 1000) + (time.tv_usec / 1000);
}

long get_elapsed_time_ms(long start_time) {
    return get_current_time_ms() - start_time;
}
```

### Sleep e Usleep

```c
#include <unistd.h>

// Sleep: segundos
sleep(2);  // Dorme 2 segundos

// Usleep: microsegundos
usleep(100000);  // Dorme 100ms

// Equivalente melhor: nanosleep
#include <time.h>

struct timespec ts;
ts.tv_sec = 0;
ts.tv_nsec = 100000000;  // 100ms em nanosegundos
nanosleep(&ts, NULL);
```

### Simulando Tempo de Vida

```c
long philosopher_death_time = current_time + time_to_die;

void check_death() {
    long current = get_current_time_ms();
    
    for (int i = 0; i < num_philosophers; i++) {
        long time_since_last_meal = current - philosophers[i].last_meal;
        
        if (time_since_last_meal > time_to_die) {
            printf("%ld %d died\n", current, i);
            stop_simulation();
        }
    }
}
```

### Precisão vs Performance

```c
// Muito preciso mas consome CPU (busy waiting)
while (get_current_time_ms() < end_time) {
    // Corpo vazio
}

// Melhor: Sleep em pequenos intervalos
while (get_current_time_ms() < end_time) {
    usleep(1000);  // Sleep 1ms, checar novamente
}

// Ou usar Condition Variables (mais avançado)
pthread_cond_wait(&cond, &mutex);
```

**Referências:**
- Linux man pages: `man usleep`
- Linux man pages: `man nanosleep`
- Linux man pages: `man gettimeofday`

---

## **7. OUTPUT E LOGGING**

### Format de Saída (42 Norm)

```
timestamp_ms X has taken a fork
timestamp_ms X is eating
timestamp_ms X is sleeping
timestamp_ms X is thinking
timestamp_ms X died
```

Exemplo:
```
0 0 has taken a fork
0 0 has taken a fork
0 0 is eating
10 1 has taken a fork
15 2 is thinking
```

### Implementação Segura

```c
pthread_mutex_t print_mutex = PTHREAD_MUTEX_INITIALIZER;

void safe_print(long timestamp, int id, const char* action) {
    pthread_mutex_lock(&print_mutex);
    {
        printf("%ld %d %s\n", timestamp, id, action);
        fflush(stdout);  // Garantir que imprime imediatamente
    }
    pthread_mutex_unlock(&print_mutex);
}

// Uso
long time_ms = get_current_time_ms() - start_time;
safe_print(time_ms, philosopher_id, "has taken a fork");
```

### Evitando Entrelaçamento de Output

```c
// ERRADO: Output pode ficar entrelaçado
printf("%ld %d ", timestamp, id);
printf("is eating\n");

// CORRETO: Uma única chamada de printf
printf("%ld %d is eating\n", timestamp, id);

// MELHOR: Usar mutex
pthread_mutex_lock(&print_mutex);
printf("%ld %d is eating\n", timestamp, id);
pthread_mutex_unlock(&print_mutex);
```

### Timestamps Relativos

```c
static long start_time = 0;

void initialize_time() {
    start_time = get_current_time_ms();
}

long get_relative_time() {
    return get_current_time_ms() - start_time;
}
```

**Referências:**
- C Standard Library: `man printf`
- POSIX Output: `man 3 printf`

---

## **8. ARGUMENTOS E CONFIGURAÇÃO**

### Parsing de Argumentos

```c
#include <stdlib.h>
#include <string.h>

typedef struct {
    int num_philosophers;
    long time_to_die;
    long time_to_eat;
    long time_to_sleep;
    int times_each_philosopher_must_eat;  // Opcional
} t_config;

int parse_args(int argc, char* argv[], t_config* config) {
    // Argumentos obrigatórios: 4
    // Argumento opcional: 1
    
    if (argc < 5 || argc > 6) {
        fprintf(stderr, "Usage: ./philo <num_philos> ");
        fprintf(stderr, "<time_to_die> <time_to_eat> ");
        fprintf(stderr, "<time_to_sleep> [times_must_eat]\n");
        return -1;
    }
    
    config->num_philosophers = ft_atoi(argv[1]);
    config->time_to_die = ft_atol(argv[2]);
    config->time_to_eat = ft_atol(argv[3]);
    config->time_to_sleep = ft_atol(argv[4]);
    
    if (argc == 6) {
        config->times_each_philosopher_must_eat = ft_atoi(argv[5]);
    } else {
        config->times_each_philosopher_must_eat = -1;  // Sem limite
    }
    
    return 0;
}
```

### Validação de Entrada

```c
int validate_config(t_config* config) {
    if (config->num_philosophers < 1) {
        fprintf(stderr, "Error: num_philosophers must be >= 1\n");
        return -1;
    }
    
    if (config->time_to_die <= 0 ||
        config->time_to_eat <= 0 ||
        config->time_to_sleep <= 0) {
        fprintf(stderr, "Error: times must be positive\n");
        return -1;
    }
    
    if (config->times_each_philosopher_must_eat == 0) {
        fprintf(stderr, "Error: times_must_eat must be positive or -1\n");
        return -1;
    }
    
    return 0;
}
```

### Limite de Recursos

```c
// Verificar se é possível criar N threads
#define MAX_PHILOSOPHERS 500

if (config->num_philosophers > MAX_PHILOSOPHERS) {
    fprintf(stderr, "Error: too many philosophers\n");
    return -1;
}
```

**Referências:**
- Linux man pages: `man atoi`
- C Standard Library: `stdlib.h`

---

## **9. ESTRUTURAS DE DADOS**

### Estrutura de Filósofo

```c
typedef struct s_philosopher {
    int id;
    pthread_t thread;
    long last_meal_time;
    int meals_eaten;
    t_state state;
} t_philosopher;
```

### Estrutura da Mesa (Table)

```c
typedef struct s_table {
    int num_philosophers;
    long time_to_die;
    long time_to_eat;
    long time_to_sleep;
    int times_must_eat;
    
    // Sincronização
    pthread_mutex_t* fork_mutexes;
    pthread_mutex_t state_mutex;
    pthread_mutex_t print_mutex;
    
    // Dados compartilhados
    t_philosopher* philosophers;
    int simulation_running;
    long start_time;
} t_table;
```

### Alocação Segura

```c
t_table* init_table(t_config* config) {
    t_table* table = malloc(sizeof(t_table));
    if (!table) {
        perror("malloc");
        return NULL;
    }
    
    table->num_philosophers = config->num_philosophers;
    table->time_to_die = config->time_to_die;
    table->time_to_eat = config->time_to_eat;
    table->time_to_sleep = config->time_to_sleep;
    table->times_must_eat = config->times_each_philosopher_must_eat;
    
    // Alocar array de forks
    table->fork_mutexes = malloc(sizeof(pthread_mutex_t) * config->num_philosophers);
    if (!table->fork_mutexes) {
        free(table);
        return NULL;
    }
    
    // Inicializar mutexes
    for (int i = 0; i < config->num_philosophers; i++) {
        if (pthread_mutex_init(&table->fork_mutexes[i], NULL) != 0) {
            perror("pthread_mutex_init");
            free(table->fork_mutexes);
            free(table);
            return NULL;
        }
    }
    
    // ... inicializar outros campos ...
    
    return table;
}
```

### Liberação Segura

```c
void cleanup_table(t_table* table) {
    if (!table)
        return;
    
    // Esperar todas as threads
    for (int i = 0; i < table->num_philosophers; i++) {
        pthread_join(table->philosophers[i].thread, NULL);
    }
    
    // Destruir mutexes
    for (int i = 0; i < table->num_philosophers; i++) {
        pthread_mutex_destroy(&table->fork_mutexes[i]);
    }
    pthread_mutex_destroy(&table->state_mutex);
    pthread_mutex_destroy(&table->print_mutex);
    
    // Liberar memória
    free(table->fork_mutexes);
    free(table->philosophers);
    free(table);
}
```

**Referências:**
- C Memory Management: `man malloc`
- POSIX Threads: `man pthread_mutex_init`

---

## **10. EDGE CASES E PROBLEMAS COMUNS**

### 1. Deadlock Infinito

**Problema**:
```
Todos pegam garfo esquerdo → Nenhém consegue pegar direito → IMPASSE
```

**Detecção**:
- Processo não termina
- Sem output novo por um tempo
- Usar `strace -p PID` para ver onde está preso

**Solução**: Ver estratégias de solução (seção 5)

### 2. Starvation

**Problema**:
```
Filósofos 0 e 1 ficam comendo
Filósofo 2 nunca consegue comer
```

**Detecção**:
```
1000 2 is thinking
2000 0 is eating
2000 1 is thinking
3000 0 is thinking
3000 1 is eating
... 2 nunca come ...
```

**Solução**: Ordem justa de acesso aos garfos

### 3. Mutexes Não Inicializados

```c
// ERRADO
pthread_mutex_t mutex;
pthread_mutex_lock(&mutex);  // Comportamento indefinido!

// CORRETO
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_lock(&mutex);

// OU
pthread_mutex_t mutex;
pthread_mutex_init(&mutex, NULL);
// ... uso ...
pthread_mutex_destroy(&mutex);
```

### 4. Memory Leaks

```c
// ERRADO: Memory leak
void* thread_args = malloc(sizeof(int));
pthread_create(&thread, NULL, func, thread_args);
pthread_join(thread, NULL);
free(thread_args);  // MUITO TARDE!

// CORRETO: Thread libera antes de terminar
void* func(void* arg) {
    int* data = (int*)arg;
    // ... usar data ...
    free(data);
    return NULL;
}

// OU
void* thread_args = malloc(sizeof(int));
pthread_create(&thread, NULL, func, thread_args);
// ... fazer outras coisas ...
pthread_join(thread, NULL);
```

### 5. Cleanup Incompleto

```c
// ERRADO: Não libera mutexes
void main_loop() {
    if (error_condition) {
        return;  // Mutex não foi destruído!
    }
}

// CORRETO: Usar cleanup handler
void cleanup_mutexes(void* arg) {
    pthread_mutex_t* mutex = (pthread_mutex_t*)arg;
    pthread_mutex_unlock(mutex);
}

void safe_section() {
    pthread_mutex_lock(&mutex);
    pthread_cleanup_push(cleanup_mutexes, &mutex);
    
    // Código seguro aqui
    
    pthread_cleanup_pop(1);  // 1 = executar handler
}
```

### 6. Race Condition em Leitura

```c
// ERRADO: Pode ler valor sendo modificado
if (simulation_running) {  // Outra thread pode mudar isso aqui
    // ... fazer algo ...
}

// CORRETO: Proteger leitura também
pthread_mutex_lock(&state_mutex);
{
    int running = simulation_running;
}
pthread_mutex_unlock(&state_mutex);

if (running) {
    // ... fazer algo ...
}
```

### 7. Timeout de Morte

**Problema**: Filósofo não morre no tempo correto

```c
// ERRADO: Checagem muito rara
while (1) {
    eat();
    sleep(10);  // Pode morrer 10 segundos atrasado!
}

// CORRETO: Checagem frequente
while (1) {
    long now = get_current_time_ms();
    long time_since_meal = now - philosopher->last_meal;
    
    if (time_since_meal > time_to_die) {
        printf("%ld %d died\n", get_relative_time(), philosopher->id);
        return;
    }
    
    usleep(100);  // Checar frequentemente
}
```

### 8. Número Ímpar de Filósofos

**Problema**: Podem ficar todos tentando pegar garfo esquerdo

**Solução**: Alternância de ordem
```c
if (philosopher->id % 2 == 0) {
    pegar_esquerdo();
    pegar_direito();
} else {
    pegar_direito();
    pegar_esquerdo();
}
```

**Referências:**
- "The C Programming Language" - Kernighan & Ritchie - Cap. 8 (I/O)
- POSIX.1-2017 Errors and Error Handling

---

## **11. SINAIS UNIX**

### O que São Sinais?

Sinais são **eventos assíncronos** que podem interromper um processo:

```
Ctrl+C   → SIGINT   → Parar programa
Ctrl+Z   → SIGSTOP  → Suspender programa
Ctrl+\   → SIGQUIT  → Quit com core dump
kill PID → SIGTERM  → Terminar programa
```

### Signal Handlers

```c
#include <signal.h>

int should_exit = 0;

void signal_handler(int sig) {
    if (sig == SIGINT) {
        printf("\nRecebido SIGINT\n");
        should_exit = 1;
    }
}

int main() {
    signal(SIGINT, signal_handler);
    
    while (!should_exit) {
        // ... main loop ...
    }
    
    return 0;
}
```

### Sincronização com Sinais em Threads

```c
#include <signal.h>

volatile sig_atomic_t stop_flag = 0;

void sig_handler(int sig) {
    stop_flag = 1;
}

void* philosopher_routine(void* arg) {
    while (!stop_flag) {
        // ... filosofar ...
    }
    return NULL;
}

int main() {
    signal(SIGINT, sig_handler);
    signal(SIGTERM, sig_handler);
    
    // ... criar threads ...
    
    // Esperar por sinal
    while (!stop_flag) {
        usleep(100);
    }
    
    // Cleanup
    cleanup_threads();
}
```

### Handling de Sinais em Multi-thread

```c
#include <pthread.h>
#include <signal.h>

void* signal_thread(void* arg) {
    sigset_t* set = (sigset_t*)arg;
    int sig;
    
    // Esperar por sinais de forma síncrona
    if (sigwait(set, &sig) == 0) {
        printf("Recebido sinal %d\n", sig);
        // Fazer cleanup
    }
    
    return NULL;
}

int main() {
    sigset_t set;
    pthread_t sig_handler_thread;
    
    // Bloquear SIGINT em todas as threads
    sigemptyset(&set);
    sigaddset(&set, SIGINT);
    pthread_sigmask(SIG_BLOCK, &set, NULL);
    
    // Criar thread dedicada para sinais
    pthread_create(&sig_handler_thread, NULL, signal_thread, &set);
    
    // ... resto do programa ...
}
```

### Cleanup ao Receber Sinal

```c
volatile sig_atomic_t cleanup_requested = 0;

void signal_handler(int sig) {
    cleanup_requested = 1;
}

int main() {
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    // Main loop
    while (1) {
        if (cleanup_requested) {
            printf("Fazendo cleanup...\n");
            
            // Parar todas as threads
            stop_simulation = 1;
            
            // Esperar threads terminarem
            for (int i = 0; i < num_philosophers; i++) {
                pthread_join(philosophers[i].thread, NULL);
            }
            
            // Liberar recursos
            cleanup_table(table);
            
            printf("Programa terminado\n");
            exit(0);
        }
        
        usleep(100);
    }
}
```

**Referências:**
- Linux man pages: `man signal`
- Linux man pages: `man sigwait`
- POSIX.1-2017 Signal Concepts

---

## **12. DEBUGGING**

### Compilação com Debug

```bash
# Adicionar símbolos de debug
gcc -g -Wall -Wextra -Werror -pthread -o philo *.c

# Com informações adicionais
gcc -g3 -ggdb -Wall -Wextra -Werror -pthread -o philo *.c
```

### GDB (GNU Debugger)

```bash
# Iniciar GDB
gdb ./philo

# Dentro de GDB
(gdb) run arg1 arg2 arg3 arg4  # Executar com argumentos
(gdb) break main               # Breakpoint em main
(gdb) break file.c:42          # Breakpoint em linha específica
(gdb) continue                 # Continuar execução
(gdb) next                     # Próxima linha
(gdb) step                     # Entrar em função
(gdb) print variavel           # Imprimir valor
(gdb) info threads             # Ver threads ativas
(gdb) thread 2                 # Mudar para thread 2
(gdb) backtrace                # Stack trace
(gdb) quit                     # Sair
```

### Valgrind (Memory Debugger)

```bash
# Detectar memory leaks
valgrind --leak-check=full --show-leak-kinds=all ./philo 5 800 200 200

# Opções úteis
--leak-check=full              # Relatório detalhado
--show-leak-kinds=all          # Mostrar todos os tipos
--track-origins=yes            # Rastrear origem de valores
--log-file=valgrind.log        # Salvar em arquivo
```

### Detecção de Race Conditions

```bash
# Usar Helgrind (parte de Valgrind)
valgrind --tool=helgrind ./philo 5 800 200 200

# Detecta:
# - Accesso a dados não protegidos
# - Locks em ordem errada
# - Deadlocks potenciais
```

### ThreadSanitizer (Google)

```bash
# Compilar com -fsanitize=thread
gcc -g -Wall -Wextra -Werror -pthread -fsanitize=thread -o philo *.c

# Executar (mostra race conditions)
./philo 5 800 200 200
```

### Debugging Manual

```c
// Adicionar logs de debug
#ifdef DEBUG
#define DEBUG_PRINT(fmt, ...) \
    fprintf(stderr, "[DEBUG] " fmt "\n", ##__VA_ARGS__)
#else
#define DEBUG_PRINT(fmt, ...)
#endif

// Uso
DEBUG_PRINT("Thread %d tentando pegar garfo %d", id, fork_id);
```

### Verificação de Deadlock

```bash
# Terminal 1: Rodar programa
./philo 5 800 200 200

# Terminal 2: Se travar, encontrar processo
ps aux | grep philo

# Terminal 3: Ver stack trace
strace -p 12345  # PID do processo

# Se preso em poll/select/nanosleep:
# Provavelmente esperando por algo que nunca vem (deadlock)
```

### Teste de Stress

```bash
# Rodar múltiplas vezes para encontrar race conditions
for i in {1..100}; do
    ./philo 5 800 200 200 > /dev/null || echo "Falha em iteração $i"
done

# Com ThreadSanitizer ativado
TSAN_OPTIONS=verbosity=1 ./philo 5 800 200 200
```

**Referências:**
- GDB Manual: `man gdb`
- Valgrind Manual: `valgrind --help`
- ThreadSanitizer: https://github.com/google/sanitizers

---

## **REFERÊNCIAS GERAIS**

### Livros Recomendados

1. **"Operating System Concepts"** - Silberschatz, Galvin, Gagne
   - Capítulos 4-5: Processos e Threads
   - Capítulo 7-8: Sincronização e Deadlock

2. **"Programming with POSIX Threads"** - David Butenhof
   - Referência completa de pthreads
   - Exemplos práticos

3. **"The C Programming Language"** (Second Edition) - Kernighan & Ritchie
   - Cap. 8: I/O e funções de biblioteca
   - Cap. 6: Estruturas

### Documentação Online

- **Linux man pages**: `man pthread_create`, `man pthread_mutex_lock`, etc.
- **POSIX.1-2017**: https://pubs.opengroup.org/onlinepubs/9699919799/
- **GCC/GDB Docs**: https://gcc.gnu.org/, https://www.sourceware.org/gdb/

### Artigos Acadêmicos

- Dijkstra, E. W. "Hierarchical Ordering of Sequential Processes" (1971)
- Chandy, K. M., & Misra, J. "The Drinking Philosophers Problem" (1984)

### Recursos 42

- 42 Wiki: Multi-threading
- Projeto Philosophers: Especificação completa
- Aulas de sistemas operacionais

---

## **ROTEIRO DE ESTUDO RECOMENDADO**

### Semana 1: Conceitos Teóricos
- [ ] Ler Seções 1-4 (Fundamentos, Mutexes, Threads POSIX, Problema)
- [ ] Fazer exercícios simples de threading
- [ ] Entender deadlock e starvation

### Semana 2: Estratégias e Sincronização
- [ ] Ler Seção 5 (Estratégias de solução)
- [ ] Implementar 2-3 estratégias diferentes
- [ ] Testar com Valgrind

### Semana 3: Estrutura e Otimização
- [ ] Ler Seções 6-9 (Timing, Output, Argumentos, Estruturas)
- [ ] Implementar parser de argumentos robusto
- [ ] Implementar sistema de logging seguro

### Semana 4: Refinamento e Debug
- [ ] Ler Seções 10-12 (Edge Cases, Sinais, Debugging)
- [ ] Testar com ThreadSanitizer
- [ ] Resolver deadlocks e race conditions

### Semana 5: Projeto Final
- [ ] Integrar tudo em solução completa
- [ ] Testar intensamente com stress tests
- [ ] Otimizar performance

---

**Última atualização**: 20 de dezembro de 2025

