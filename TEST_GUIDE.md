# 🧪 Guia de Testes - Philosophers

## 📋 Visão Geral

Script completo de testes para o projeto **Philosophers** da 42, incluindo casos extremos para a parte mandatória e bônus.

## 🚀 Como Usar

### Uso Básico

```bash
# Testar tudo (mandatório + bônus + memory + data races)
./test_philosophers.sh all

# Testar apenas a parte mandatória
./test_philosophers.sh mandatory

# Testar apenas o bônus
./test_philosophers.sh bonus

# Testar memory leaks (requer valgrind)
./test_philosophers.sh memory

# Testar data races (requer philo_tsan)
./test_philosophers.sh tsan
```

### Pré-requisitos

1. **Compilar o projeto primeiro:**
   ```bash
   make        # Para philo
   make bonus  # Para philo_bonus (opcional)
   ```

2. **Para testes de memória (opcional):**
   ```bash
   sudo apt-get install valgrind
   ```

3. **Para testes de data race (opcional):**
   ```bash
   cc -g -fsanitize=thread -pthread -o philo_tsan src/*.c -I includes
   ```

## 📊 Categorias de Testes

### 1. **Edge Cases - Filósofo Único**
- ✓ 1 filósofo deve morrer (não há garfos suficientes)
- ✓ Testa diferentes tempos de morte (800ms, 400ms, 200ms)

### 2. **Edge Cases - Dois Filósofos**
- ✓ Casos onde devem morrer
- ✓ Casos onde não devem morrer
- ✓ Timing crítico com 2 filósofos

### 3. **Testes do Subject**
- ✓ `5 800 200 200` - Ninguém deve morrer
- ✓ `4 410 200 200` - Ninguém deve morrer
- ✓ `4 310 200 100` - Devem morrer por volta de 310ms
- ✓ E outros casos especificados no subject

### 4. **Timing Apertado**
- ✓ Casos onde o tempo de morte é muito próximo do tempo necessário para comer
- ✓ Testa a precisão do monitor de morte

### 5. **Grande Número de Filósofos**
- ✓ 100 filósofos
- ✓ 200 filósofos
- ✓ Testa performance e sincronização em escala

### 6. **Contagem de Refeições**
- ✓ Verifica se a simulação para quando todos comeram N vezes
- ✓ Valida que nenhum filósofo morre antes de completar as refeições

### 7. **Timing Extremo**
- ✓ Tempos muito grandes (2000ms)
- ✓ Tempos muito pequenos (50ms)
- ✓ Testa os limites do sistema

### 8. **Número Ímpar de Filósofos**
- ✓ 3, 5, 7, 9 filósofos
- ✓ Casos mais difíceis de sincronizar

### 9. **Argumentos Inválidos**
- ✓ Zero filósofos
- ✓ Números negativos
- ✓ Overflow de inteiros
- ✓ Verifica que o programa não crasha

### 10. **Stress Tests**
- ✓ Execução prolongada (20-30s)
- ✓ Grande número de filósofos por tempo estendido
- ✓ Detecta race conditions e problemas de sincronização

### 11. **Bônus - Processos e Semáforos**
- ✓ Todos os testes acima adaptados para a versão com processos
- ✓ Testa a limpeza correta de processos filhos
- ✓ Valida uso de semáforos nomeados

### 12. **Memory Leaks (Valgrind)**
- ✓ Detecta vazamentos de memória
- ✓ Verifica liberação correta de recursos

### 13. **Data Races (Thread Sanitizer)**
- ✓ Detecta condições de corrida
- ✓ Identifica acessos concorrentes sem proteção

## 📈 Interpretando os Resultados

### Cores do Output

- 🟢 **Verde (PASSED)** - Teste passou com sucesso
- 🔴 **Vermelho (FAILED)** - Teste falhou
- 🟡 **Amarelo (WARNING)** - Aviso, pode não ser crítico
- 🔵 **Azul (INFO)** - Informação adicional

### Critérios de Sucesso

**Teste de "Não deve morrer":**
- ✅ Nenhum filósofo morre no tempo especificado
- ✅ Simulação roda sem travamentos

**Teste de "Deve morrer":**
- ✅ Um filósofo morre no tempo esperado (±10ms de tolerância)
- ✅ Mensagem de morte aparece no output

**Teste de refeições:**
- ✅ Todos os filósofos comem pelo menos N vezes
- ✅ Simulação para automaticamente após N refeições
- ✅ Nenhum filósofo morre antes de completar as refeições

**Teste de crash:**
- ✅ Programa não gera segfault
- ✅ Programa não gera abort/bus error
- ✅ Argumentos inválidos são tratados graciosamente

## 🐛 Debugging

Se um teste falhar, você pode rodar manualmente:

```bash
# Rodando um teste específico
./philo 4 310 200 100

# Com mais tempo para observar
./philo 5 800 200 200 7

# Verificando o output completo
./philo 4 410 200 200 5 > output.log
cat output.log
```

### Verificando Memory Leaks Manualmente

```bash
valgrind --leak-check=full --show-leak-kinds=all \
  ./philo 4 410 200 200 5
```

### Verificando Data Races Manualmente

```bash
# Compilar com thread sanitizer
cc -g -fsanitize=thread -pthread -o philo_tsan src/*.c -I includes

# Executar
./philo_tsan 4 410 200 200 5
```

## 📋 Checklist de Validação

Antes de submeter o projeto, certifique-se que:

- [ ] Todos os testes mandatórios passam
- [ ] Não há memory leaks
- [ ] Não há data races
- [ ] Filósofos não morrem quando não devem
- [ ] Filósofos morrem no tempo correto quando devem
- [ ] Simulação para corretamente com contagem de refeições
- [ ] Funciona com 1 filósofo
- [ ] Funciona com 200 filósofos
- [ ] Funciona com números ímpares de filósofos
- [ ] Argumentos inválidos são tratados sem crash
- [ ] (Bônus) Todos os testes com processos passam
- [ ] (Bônus) Não há processos órfãos

## 🎯 Casos de Teste Críticos

Estes são os casos mais importantes que você **DEVE** passar:

### Obrigatórios

```bash
./philo 1 800 200 200          # Deve morrer em ~800ms
./philo 4 410 200 200          # Ninguém deve morrer
./philo 5 800 200 200          # Ninguém deve morrer
./philo 4 310 200 100          # Deve morrer em ~310ms
./philo 4 410 200 200 7        # Deve parar após 7 refeições
./philo 2 400 200 200          # Ninguém deve morrer
```

### Bônus

```bash
./philo_bonus 1 800 200 200    # Deve morrer em ~800ms
./philo_bonus 4 410 200 200    # Ninguém deve morrer
./philo_bonus 5 800 200 200 7  # Deve parar após 7 refeições
```

## 🔧 Troubleshooting

### "Philosopher died when they shouldn't"
- ➜ Seu monitor de morte está muito sensível ou tem race condition
- ➜ Verifique a proteção com mutex ao atualizar last_meal
- ➜ Certifique-se que time_to_die > time_to_eat

### "No philosopher died when one should"
- ➜ Seu monitor de morte não está funcionando
- ➜ Verifique se a thread de monitoramento está rodando
- ➜ Verifique se está calculando corretamente o tempo desde a última refeição

### "Simulation didn't stop after meals"
- ➜ Não está verificando corretamente se todos comeram N vezes
- ➜ Contador de refeições não está sendo atualizado
- ➜ Faltando condição de parada no monitor

### "Data race detected"
- ➜ Acessando variáveis compartilhadas sem mutex
- ➜ Proteja: last_meal, dead flag, meal_count, print statements

### "Memory leaks detected"
- ➜ Não está liberando threads/mutexes
- ➜ Não está fazendo pthread_join
- ➜ Não está fazendo pthread_mutex_destroy
- ➜ Não está liberando malloc

## 💡 Dicas

1. **Comece pelos casos simples** (1 filósofo, 2 filósofos)
2. **Teste frequentemente** durante o desenvolvimento
3. **Use valgrind** desde o início para evitar leaks
4. **Use thread sanitizer** para detectar race conditions
5. **Adicione logs** temporários para debug (remova depois)
6. **Teste com diferentes números** de filósofos
7. **Não ignore warnings** do compilador

## 📚 Recursos Adicionais

- [Subject oficial](PHILOSOPHERS_SPECIFICATION.md)
- [Estrutura do projeto](STRUCTURE_PLAN.md)
- [Roadmap](PHILOSOPHERS_ROADMAP.md)

## 🤝 Contribuindo

Se encontrar casos de teste adicionais que deveriam ser incluídos, sinta-se livre para adicionar!

---

**Boa sorte com o projeto! 🎉**
