# 🧪 Scripts de Teste - Philosophers

## 📦 Arquivos Criados

### 1. **test_philosophers.sh** (Principal)
Script completo de testes com 40+ casos de teste extremos.

**Executáveis testados:**
- `./philo` - Parte mandatória (threads + mutexes)
- `./philo_bonus` - Parte bônus (processos + semáforos)
- `./philo_tsan` - Versão com Thread Sanitizer (compilar com compile_tsan.sh)

**Uso:**
```bash
./test_philosophers.sh all         # Todos os testes
./test_philosophers.sh mandatory   # Apenas mandatório
./test_philosophers.sh bonus       # Apenas bônus
./test_philosophers.sh memory      # Valgrind (memory leaks)
./test_philosophers.sh tsan        # Thread Sanitizer (data races)

# Modo debug (mostra output quando falha)
DEBUG=1 ./test_philosophers.sh mandatory
```

### 2. **compile_tsan.sh**
Compila o projeto com Thread Sanitizer para detectar data races.

**Uso:**
```bash
./compile_tsan.sh
./philo_tsan 4 410 200 200 5
```

### 3. **quick_tests.sh**
Mostra exemplos de comandos de teste rápidos.

**Uso:**
```bash
./quick_tests.sh   # Exibe lista de testes rápidos
```

### 4. **TEST_GUIDE.md**
Documentação completa sobre os testes, categorias e debugging.

## 🚀 Início Rápido

```bash
# 1. Compilar o projeto
make
make bonus  # opcional

# 2. Rodar todos os testes
./test_philosophers.sh all

# 3. Ver exemplos de testes individuais
./quick_tests.sh
```

## ✅ Principais Testes

### Mandatório
- ✓ 1 filósofo deve morrer
- ✓ 4 410 200 200 - ninguém morre
- ✓ 5 800 200 200 - ninguém morre
- ✓ 4 310 200 100 - deve morrer ~310ms
- ✓ 100+ filósofos
- ✓ Contagem de refeições

### Bônus
- ✓ Mesmos testes com processos e semáforos
- ✓ Limpeza correta de processos

### Qualidade
- ✓ Sem memory leaks (valgrind)
- ✓ Sem data races (thread sanitizer)
- ✓ Argumentos inválidos tratados

## 📊 Categorias de Teste (40+ testes)

1. **Edge Cases** - Filósofo único, dois filósofos
2. **Subject Tests** - Casos obrigatórios do subject
3. **Tight Timing** - Tempos críticos
4. **Large Scale** - 100-200 filósofos
5. **Meal Count** - Parada após N refeições
6. **Extreme Timing** - Tempos mínimos e máximos
7. **Odd Numbers** - Números ímpares de filósofos
8. **Invalid Args** - Tratamento de erros
9. **Stress Tests** - Testes prolongados
10. **Bonus Tests** - Versão com processos

## 🐛 Debugging

```bash
# Memory leaks
valgrind --leak-check=full ./philo 4 410 200 200 5

# Data races
./compile_tsan.sh
./philo_tsan 4 410 200 200 5

# Output detalhado
./philo 5 800 200 200 7 > output.log
```

## 📈 Interpretação dos Resultados

- 🟢 **PASSED** - Teste passou
- 🔴 **FAILED** - Teste falhou
- 🟡 **WARNING** - Aviso não crítico
- 🔵 **INFO** - Informação adicional

## 🎯 Checklist Pré-Submissão

- [ ] `./test_philosophers.sh mandatory` - 100% passed
- [ ] `./test_philosophers.sh bonus` - 100% passed (se aplicável)
- [ ] `./test_philosophers.sh memory` - No leaks
- [ ] `./test_philosophers.sh tsan` - No data races
- [ ] Norminette OK
- [ ] Makefile correto (all, clean, fclean, re)
- [ ] Sem variáveis globais
- [ ] README atualizado

## 💡 Dicas

1. **Teste frequentemente** durante o desenvolvimento
2. **Comece simples** (1-2 filósofos) antes de aumentar
3. **Use valgrind cedo** para evitar acumular leaks
4. **Thread sanitizer é seu amigo** para detectar races
5. **Teste casos extremos** não apenas os do subject
6. **Verifique timing de morte** com precisão de ±10ms

## 📚 Mais Informações

Consulte [TEST_GUIDE.md](TEST_GUIDE.md) para documentação completa sobre:
- Descrição detalhada de cada categoria de teste
- Troubleshooting para problemas comuns
- Como interpretar falhas específicas
- Recursos adicionais para aprendizado

---

**Criado para o projeto Philosophers da 42 School**
