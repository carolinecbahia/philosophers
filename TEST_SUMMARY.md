# 🎯 PHILOSOPHERS - SISTEMA COMPLETO DE TESTES

## 📦 Arquivos Criados

| Arquivo | Tamanho | Descrição |
|---------|---------|-----------|
| `test_philosophers.sh` | 16K | Script principal com 40+ testes automatizados |
| `TEST_GUIDE.md` | 7.4K | Documentação completa dos testes |
| `TESTING_README.md` | 3.5K | Guia rápido de uso |
| `check_output.sh` | 6.1K | Analisador de output do philosophers |
| `compile_tsan.sh` | 1.3K | Compilador com Thread Sanitizer |
| `quick_tests.sh` | 1.3K | Exemplos de testes rápidos |

**Total: ~35KB de scripts e documentação**

---

## 🚀 INÍCIO RÁPIDO

### 1. Compilar
```bash
make           # Compilar philo (mandatório)
make bonus     # Compilar philo_bonus (bônus - processos)
```

**Executáveis gerados:**
- `./philo` → Parte mandatória (threads + mutexes)
- `./philo_bonus` → Parte bônus (processos + semáforos)

### 2. Rodar Todos os Testes
```bash
./test_philosophers.sh all
```

### 3. Ver Exemplos
```bash
./quick_tests.sh
```

---

## 📋 COMANDOS PRINCIPAIS

### Testes Automatizados
```bash
./test_philosophers.sh all         # Tudo (40+ testes)
./test_philosophers.sh mandatory   # Apenas mandatório
./test_philosophers.sh bonus       # Apenas bônus
./test_philosophers.sh memory      # Memory leaks (valgrind)
./test_philosophers.sh tsan        # Data races (thread sanitizer)
```

### Análise de Output
```bash
./philo 5 800 200 200 | ./check_output.sh
# ou
./philo 4 410 200 200 > output.log
./check_output.sh output.log
```

### Compilação com Thread Sanitizer
```bash
./compile_tsan.sh
./philo_tsan 4 410 200 200 5
```

---

## ✅ CATEGORIAS DE TESTE (40+ testes)

### 🔴 Testes Críticos (Obrigatórios)
1. **Filósofo Único** - Deve morrer (sem garfos suficientes)
2. **Dois Filósofos** - Casos de morte e sobrevivência
3. **Subject Tests** - Casos do subject oficial
4. **Timing Crítico** - Testes de precisão temporal
5. **Grande Escala** - 100-200 filósofos
6. **Contagem de Refeições** - Parada após N refeições
7. **Timing Extremo** - Valores min/max
8. **Números Ímpares** - 3, 5, 7, 9 filósofos
9. **Argumentos Inválidos** - Tratamento de erros
10. **Stress Tests** - Testes prolongados

### 🟢 Testes de Qualidade
11. **Memory Leaks** - Valgrind
12. **Data Races** - Thread Sanitizer
13. **Output Analysis** - Verificação de formato

### 🔵 Testes Bônus
14. **Processos & Semáforos** - Versão bonus
15. **Limpeza de Processos** - Sem órfãos

---

## 🧪 CASOS DE TESTE ESSENCIAIS

### Mandatório
```bash
# 1. Um filósofo (DEVE morrer)
./philo 1 800 200 200

# 2. Casos do subject (NÃO devem morrer)
./philo 5 800 200 200
./philo 4 410 200 200

# 3. Deve morrer no tempo certo
./philo 4 310 200 100    # Morte ~310ms

# 4. Contagem de refeições
./philo 5 800 200 200 7  # Para após 7 refeições

# 5. Grande escala
./philo 100 800 200 200
./philo 200 800 200 200
```

### Bônus
```bash
./philo_bonus 5 800 200 200
./philo_bonus 4 410 200 200 10
./philo_bonus 100 800 200 200
```

### Debugging
```bash
# Memory leaks
valgrind --leak-check=full ./philo 4 410 200 200 5

# Data races
./compile_tsan.sh
./philo_tsan 4 410 200 200 5

# Output analysis
./philo 5 800 200 200 | ./check_output.sh
```

---

## 📊 FEATURES DO SCRIPT DE TESTE

### ✨ Funcionalidades
- ✅ 40+ casos de teste automatizados
- ✅ Validação de timing de morte (±10ms)
- ✅ Verificação de contagem de refeições
- ✅ Detecção de crashes (segfault, bus error)
- ✅ Testes de stress (execução prolongada)
- ✅ Suporte para mandatório e bônus
- ✅ Integração com Valgrind
- ✅ Integração com Thread Sanitizer
- ✅ Output colorido e detalhado
- ✅ Sumário de resultados
- ✅ Análise de output

### 📈 Relatório de Resultados
```
Total Tests:  42
Passed:       40
Failed:       2
Success Rate: 95%
```

---

## 🐛 DEBUGGING & TROUBLESHOOTING

### Problemas Comuns

#### "Philosopher died when they shouldn't"
- Verifique proteção mutex em `last_meal`
- Certifique-se que `time_to_die > time_to_eat`
- Revise o monitor de morte

#### "No philosopher died when one should"
- Monitor de morte não está rodando
- Cálculo de tempo incorreto
- Verificação de morte não está funcionando

#### "Data race detected"
- Variáveis compartilhadas sem mutex
- Proteja: last_meal, dead flag, meal_count, prints

#### "Memory leaks detected"
- Não liberou threads (pthread_join)
- Não destruiu mutexes (pthread_mutex_destroy)
- Malloc não liberado

### Ferramentas de Debug

```bash
# 1. Valgrind completo
valgrind --leak-check=full \
         --show-leak-kinds=all \
         --track-origins=yes \
         --verbose \
         ./philo 4 410 200 200 5

# 2. Thread Sanitizer
./compile_tsan.sh
TSAN_OPTIONS="history_size=7" ./philo_tsan 4 410 200 200 5

# 3. GDB
gdb --args ./philo 4 410 200 200 5

# 4. Análise de output
./philo 5 800 200 200 > output.log
./check_output.sh output.log
grep "died" output.log
```

---

## 📚 DOCUMENTAÇÃO

### Arquivos de Referência
- `TESTING_README.md` - Guia rápido
- `TEST_GUIDE.md` - Documentação completa
- `PHILOSOPHERS_SPECIFICATION.md` - Subject oficial
- `README.md` - Visão geral do projeto

### Estrutura dos Testes
```
test_philosophers.sh
├── Utility Functions (print, check, etc)
├── Test Execution Functions
│   ├── run_test_no_death()
│   ├── run_test_should_die()
│   ├── run_test_meal_count()
│   ├── run_test_no_crash()
│   └── run_stress_test()
├── Mandatory Tests (30+ tests)
├── Bonus Tests (10+ tests)
├── Memory & Data Race Checks
└── Summary & Report
```

---

## 🎯 CHECKLIST PRÉ-SUBMISSÃO

### Código
- [ ] Compila sem warnings (`-Wall -Wextra -Werror`)
- [ ] Norminette OK
- [ ] Sem variáveis globais
- [ ] Makefile correto (all, clean, fclean, re, bonus)

### Testes Funcionais
- [ ] `./test_philosophers.sh mandatory` - 100% passed
- [ ] `./test_philosophers.sh bonus` - 100% passed
- [ ] 1 filósofo morre corretamente
- [ ] 5 800 200 200 - ninguém morre
- [ ] 4 410 200 200 - ninguém morre
- [ ] 4 310 200 100 - morre ~310ms
- [ ] Contagem de refeições funciona
- [ ] 100+ filósofos funcionam

### Qualidade
- [ ] `./test_philosophers.sh memory` - No leaks
- [ ] `./test_philosophers.sh tsan` - No data races
- [ ] Sem segfaults
- [ ] Sem deadlocks
- [ ] Timing preciso (±10ms)
- [ ] Output formatado corretamente

### Bônus
- [ ] Usa processos (não threads)
- [ ] Usa semáforos (não mutexes)
- [ ] Processos são limpos corretamente
- [ ] Sem processos órfãos

---

## 💡 DICAS FINAIS

1. **Teste desde o início** - Não deixe para o final
2. **Comece simples** - 1 filósofo, depois 2, depois mais
3. **Use valgrind cedo** - Evite acumular leaks
4. **Thread Sanitizer é essencial** - Detecta races sutis
5. **Teste casos extremos** - Não apenas os do subject
6. **Verifique timing** - Morte deve ser precisa (±10ms)
7. **Analise o output** - Use check_output.sh
8. **Teste com números grandes** - 100-200 filósofos
9. **Teste números ímpares** - Mais difícil de sincronizar
10. **Leia a documentação** - TEST_GUIDE.md tem todas as respostas

---

## 🎉 BOA SORTE!

Este sistema de testes cobre **todos os casos extremos** do projeto philosophers.
Se passar em todos os testes, seu projeto está sólido!

Para dúvidas ou problemas, consulte TEST_GUIDE.md.

---

**Created for 42 School Philosophers Project**  
**Date: Janeiro 2026**  
**Version: 1.0**
