# 📋 Philosophers - Especificação Oficial 42 (Versão Completa)

## **INFORMAÇÕES GERAIS**

**Projeto**: Philosophers (O Jantar dos Filósofos)  
**Linguagem**: C  
**Nível**: Intermediário  
**Duração**: ~3-4 semanas  
**Data**: 2025

---

## **INSTRUÇÕES COMUNS**

### Requisitos Obrigatórios

- ✅ Projeto escrito em **C puro**
- ✅ Deve respeitar a **Norma 42**
- ✅ **Sem segmentation faults, bus errors, double free**
- ✅ **Sem memory leaks**
- ✅ Compilação com `cc` e flags: `-Wall -Wextra -Werror`
- ✅ **Sem relinking desnecessário** no Makefile
- ✅ **Sem variáveis globais** (rule de ouro!)

### Makefile Obrigatório

O Makefile deve conter:
```makefile
NAME = philo              # Nome do executável

all:                      # Regra padrão
	# Compilar tudo

clean:                    # Limpar .o
	rm -f *.o

fclean: clean             # Limpar tudo
	rm -f $(NAME)

re: fclean all            # Recompilar

.PHONY: all clean fclean re
```

Se usar **libft**:
- Copiar sources em pasta `libft/`
- Compilar libft via seu Makefile
- Linkar com o projeto

### Para Bonus

- Criar arquivo `*_bonus.c` e `*_bonus.h`
- Adicionar regra `bonus` no Makefile
- Separar compilação de mandatory e bonus

### Submissão

```
Pasta do repositório:
philo/                    (mandatory)
philo_bonus/              (bonus, se aplicável)
```

---

## **INSTRUÇÕES DE IA**

### Bom Uso de AI

✅ **Use AI para:**
- Tarefas repetitivas e tediosas
- Brainstorm de ideias
- Explicações de conceitos
- Validação de lógica

✅ **Sempre:**
- Entenda completamente o código gerado
- Valide com peers
- Teste antes de usar
- Tome responsabilidade pelo código

### Má Prática

❌ **Não faça:**
- Copy-paste cego de código
- Confiar em AI sem validação
- Usar AI sem entender
- Não testar código gerado

**Lembre-se**: Durante a defesa, você precisa explicar **tudo** que fez. Se não conseguir explicar, falha!

---

## **VISÃO GERAL DO PROJETO**

### O Cenário

```
┌─────────────────────────────────┐
│   Filósofos na Mesa Redonda     │
├─────────────────────────────────┤
│  - Comendo                      │
│  - Pensando                     │
│  - Dormindo                     │
│  - Forks entre cada um          │
│  - Morte por fome               │
└─────────────────────────────────┘
```

### Objetivos

1. **Cada filósofo é uma thread** (mandatory) ou **processo** (bonus)
2. **Cada garfo é um mutex** (mandatory) ou **semáforo** (bonus)
3. **Sincronização perfeita** sem deadlock/starvation
4. **Logging corretamente formatado**
5. **Sem data races**

### Regras Fundamentais

- Filósofos **comem, pensam, dormem**
- Precisam de **2 garfos para comer** (esquerdo e direito)
- **Não se comunicam** diretamente
- **Não sabem** se outro vai morrer
- **Devem evitar morrer**

---

## **ARGUMENTOS DO PROGRAMA**

### Obrigatórios (4)

```bash
./philo number_of_philosophers time_to_die time_to_eat time_to_sleep
```

| Argumento | Tipo | Unidade | Descrição |
|-----------|------|---------|-----------|
| `number_of_philosophers` | int | - | Número de filósofos E garfos |
| `time_to_die` | long | ms | Tempo sem comer antes de morrer |
| `time_to_eat` | long | ms | Tempo que leva para comer |
| `time_to_sleep` | long | ms | Tempo que dorme |

### Opcional (1)

```bash
./philo 5 800 200 200 10
                      ↑
                Comer 10x cada = termina
```

`number_of_times_each_philosopher_must_eat`:
- Se todos comem N vezes, simulação termina
- Se não especificado: termina quando morre

### Exemplos Válidos

```bash
./philo 5 800 200 200          # Até alguém morrer
./philo 5 800 200 200 10       # Até cada um comer 10x
./philo 1 800 200 200          # Um filósofo (teste edge case)
./philo 100 1000 100 100       # Muitos filósofos
```

---

## **NUMERAÇÃO E POSICIONAMENTO**

### Filósofos

- Número: **1 até N** (não 0!)
- Filósofo **1** ao lado de filósofo **N**
- Filósofo **N** entre **N-1** e **1** (circular)

### Exemplo com 5 Filósofos

```
        1
    5       2
  4           3
```

- Filósofo 1: vizinhos 5 (esq) e 2 (dir)
- Filósofo 2: vizinhos 1 (esq) e 3 (dir)
- Filósofo 3: vizinhos 2 (esq) e 4 (dir)
- Filósofo 4: vizinhos 3 (esq) e 5 (dir)
- Filósofo 5: vizinhos 4 (esq) e 1 (dir)

### Garfos

- Garfo entre filósofo N e N+1
- Cada filósofo tem 2 garfos

---

## **LOGGING (OUTPUT)**

### Formato Obrigatório

```
timestamp_ms X has taken a fork
timestamp_ms X is eating
timestamp_ms X is sleeping
timestamp_ms X is thinking
timestamp_ms X died
```

### Explicação

| Campo | Descrição |
|-------|-----------|
| `timestamp_ms` | Tempo em ms desde o inicio do programa |
| `X` | Número do filósofo (1 a N) |
| `action` | Estado ou ação |

### Exemplo Real

```
0 1 has taken a fork
0 1 has taken a fork
0 1 is eating
100 2 has taken a fork
150 1 is sleeping
200 2 has taken a fork
201 2 is eating
300 1 is thinking
```

### Regras de Logging

1. **Sem sobreposição**: Mensagens completas, não entrelaçadas
   ```
   ✅ CORRETO:   "100 1 has taken a fork"
   ❌ ERRADO:    "100 1 has" "taken a fork"
   ```

2. **Morte dentro de 10ms**:
   - Se filósofo deveria morrer em T
   - Mensagem de morte deve sair antes de T+10ms

3. **Use mutex para print**:
   ```c
   pthread_mutex_lock(&print_mutex);
   printf("%l %d %s\n", timestamp, id, action);
   fflush(stdout);
   pthread_mutex_unlock(&print_mutex);
   ```

---

## **MANDATORY PART: PHILO (COM THREADS)**

### Estrutura

```
philo/
├── Makefile
├── philo
├── philo.h
└── src/
    ├── main.c
    ├── philo_routine.c
    ├── utils.c
    └── ...
```

### Requisitos Específicos

1. **Uma thread por filósofo**
   ```c
   for (int i = 0; i < num_philosophers; i++) {
       pthread_create(&philo[i].thread, NULL, philo_routine, &philo[i]);
   }
   ```

2. **Um mutex por garfo**
   ```c
   pthread_mutex_t forks[num_philosophers];
   
   for (int i = 0; i < num_philosophers; i++) {
       pthread_mutex_init(&forks[i], NULL);
   }
   ```

3. **Ciclo de vida do filósofo**
   ```
   Pensando → Toma garfos → Comendo → Solta garfos 
   → Dormindo → Pensando (loop)
   ```

### Exemplo Base

```c
void* philo_routine(void* arg) {
    t_philosopher* philo = (t_philosopher*)arg;
    
    while (simulation_running) {
        // Pensar
        sleep(random_time);
        
        // Tentar pegar garfos
        pthread_mutex_lock(&forks[left]);
        print_action(philo->id, "has taken a fork");
        
        pthread_mutex_lock(&forks[right]);
        print_action(philo->id, "has taken a fork");
        
        // Comer
        philo->last_meal = get_time();
        print_action(philo->id, "is eating");
        sleep(time_to_eat);
        
        // Soltar garfos
        pthread_mutex_unlock(&forks[right]);
        pthread_mutex_unlock(&forks[left]);
        
        // Dormir
        print_action(philo->id, "is sleeping");
        sleep(time_to_sleep);
        
        // Pensar
        print_action(philo->id, "is thinking");
    }
    
    return NULL;
}
```

### Compilação

```bash
cc -Wall -Wextra -Werror -pthread -o philo *.c
```

---

## **BONUS PART: PHILO_BONUS (COM PROCESSOS)**

### Estrutura

```
philo_bonus/
├── Makefile
├── philo_bonus
├── philo_bonus.h
└── src/
    ├── main.c
    ├── philosopher.c
    ├── utils.c
    └── ...
```

### Diferenças Principais

| Aspecto | Mandatory | Bonus |
|---------|-----------|-------|
| Filósofo | Thread | Processo |
| Garfo | Mutex | Semáforo |
| Garfos | Array de mutexes | 1 semáforo contador |
| Posição | Privada | Compartilhada |

### Um Semáforo para N Garfos

```c
#include <semaphore.h>

// Criar semáforo (N garfos disponíveis)
sem_t *forks = sem_open("/philo_forks", O_CREAT, 0644, num_philosophers);

// Pegar garfo
sem_wait(forks);  // Decrementa (1 garfo a menos)

// Usar...

// Largar garfo
sem_post(forks);  // Incrementa (1 garfo a mais)

// Cleanup
sem_close(forks);
sem_unlink("/philo_forks");
```

### Estrutura com Processos

```c
void main_loop(void) {
    for (int i = 0; i < num_philosophers; i++) {
        pid_t pid = fork();
        
        if (pid == 0) {
            // Processo filho: philosopher
            philosopher_routine(i);
            exit(0);
        }
    }
    
    // Processo pai: monitora morte
    monitor_philosophers();
    
    // Esperar filhos
    for (int i = 0; i < num_philosophers; i++) {
        waitpid(pids[i], NULL, 0);
    }
}
```

### Compilação

```bash
cc -Wall -Wextra -Werror -o philo_bonus *.c
```

---

## **FUNÇÕES AUTORIZADAS**

### Mandatory

```c
memset              // Limpar memória
printf              // Print
malloc, free        // Memória
write               // Escrever em file descriptor
usleep              // Sleep em microsegundos
gettimeofday        // Pegar tempo atual
pthread_create      // Criar thread
pthread_detach      // Detach de thread
pthread_join        // Esperar thread
pthread_mutex_init  // Inicializar mutex
pthread_mutex_destroy
pthread_mutex_lock
pthread_mutex_unlock
```

### Bonus (adicional)

```c
fork                // Criar processo
kill                // Enviar sinal
exit                // Terminar processo
waitpid             // Esperar processo
sem_open            // Criar/abrir semáforo
sem_close           // Fechar semáforo
sem_post            // Incrementar semáforo
sem_wait            // Decrementar semáforo (bloqueia)
sem_unlink          // Remover semáforo
```

---

## **CHECKLIST DE IMPLEMENTAÇÃO**

### Fase 1: Setup

- [ ] Makefile funcional com all, clean, fclean, re
- [ ] Parsing de argumentos validado
- [ ] Estruturas de dados definidas
- [ ] Sem variáveis globais

### Fase 2: Sincronização Básica

- [ ] Mutexes inicializados e destruídos
- [ ] Threads criadas corretamente
- [ ] Filosófos pensam, comem, dormem (ordem básica)

### Fase 3: Lógica de Garfos

- [ ] Pegar 2 garfos antes de comer
- [ ] Proteger estado dos garfos com mutex
- [ ] Sem deadlock em pequenos testes

### Fase 4: Logging

- [ ] Formatação correta de mensagens
- [ ] Timestamps em millisegundos
- [ ] Sem mensagens entrelaçadas (mutex de print)

### Fase 5: Timing

- [ ] Contagem de tempo funcionando
- [ ] Filósofo morre se não comer a tempo
- [ ] Mensagem de morte dentro de 10ms

### Fase 6: Testes

- [ ] Sem memory leaks (Valgrind)
- [ ] Sem data races (ThreadSanitizer)
- [ ] Sem segfault
- [ ] Compilação sem warnings

### Fase 7: Refinamento

- [ ] Norminette clean
- [ ] Performance otimizada
- [ ] Edge cases testados

### Bonus

- [ ] Philo_bonus compilado
- [ ] Processos + semáforos funcionando
- [ ] Mesma lógica, diferente implementação

---

## **EDGE CASES CRÍTICOS**

### 1. Um Filósofo

```bash
./philo 1 800 200 200
```

- Pega 1 garfo (o mesmo da esquerda e direita)
- Não consegue pegar 2 → deadlock?
- Deve morrer após 800ms

**Solução**: Verificar se `num_philosophers == 1`, tratar especialmente

### 2. Filósofos Agem Rápido Demais

Se `time_to_eat` muito pequeno e muitos filósofos, todos podem morrer rápido.

**Validação**: Argumentos realistas

### 3. Tempo de Morte Crítico

Filósofo deveria morrer em 1000ms, mas sistema estava ocupado:

**Solução**: Checar morte frequentemente (a cada 1-10ms)

### 4. Memory Leak em Cleanup

Threads não foram terminadas corretamente

**Solução**: `pthread_join` ou `pthread_detach` em todas

### 5. Stdout Entrelaçado

```
Esperado: "100 1 is eating"
Recebido: "100 1" "is eating" (em linhas diferentes!)
```

**Solução**: Uma única operação `printf` dentro de mutex

---

## **DEBUGGING RÁPIDO**

### Testar com Valgrind

```bash
valgrind --leak-check=full --show-leak-kinds=all ./philo 5 800 200 200
```

### Testar com ThreadSanitizer

```bash
gcc -g -Wall -Wextra -Werror -pthread -fsanitize=thread -o philo *.c
./philo 5 800 200 200
```

### Testar Manualmente

```bash
# Terminal 1
./philo 5 800 200 200

# Observar:
# - Output bem formatado?
# - Alguém morre?
# - Quando termina?

# Ctrl+C para parar
```

### Stress Test

```bash
for i in {1..50}; do
    echo "Teste $i"
    ./philo 5 800 200 200 > /dev/null || echo "FALHOU"
done
```

---

## **AVALIAÇÃO**

### Critério de Sucesso

✅ Código funcional sem crashes  
✅ Sem memory leaks  
✅ Sem data races  
✅ Norma 42 aprovada  
✅ Logging correto  
✅ Argumentos validados  
✅ Makefile funcional  

### Durante a Defesa

- Explicar escolhas de sincronização
- Mostrar como evitou deadlock
- Demonstrar com argumentos variados
- Responder sobre edge cases
- **Ser capaz de fazer pequenas modificações**

---

## **DICAS FINAIS**

### ✅ Faça

- Comece simples, melhore depois
- Use testes frequentemente
- Revise com peers
- Documente decisões importantes
- Teste edge cases

### ❌ Evite

- Usar variáveis globais
- Confiar em AI sem entender
- Copy-paste cego
- Deixar para testar no final
- Ignorar warnings do compilador

### 📚 Recursos

- Man pages: `man pthread_*`, `man sem_*`
- Debugging: GDB, Valgrind, ThreadSanitizer
- Peers: Discussão e revisão crítica
- Roadmap: [PHILOSOPHERS_ROADMAP.md](PHILOSOPHERS_ROADMAP.md)

---

**Data de Atualização**: 20 de dezembro de 2025  
**Versão**: 1.0 Completa

