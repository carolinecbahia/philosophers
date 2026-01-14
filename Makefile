# **************************************************************************** #
#                                                                              #
#                                                          :::      ::::::::   #
#   Makefile                                             :+:      :+:    :+:   #
#                                                      +:+ +:+         +:+     #
#   By: ccavalca <ccavalca@student.42sp.org.br>      +#+  +:+       +#+        #
#                                                  +#+#+#+#+#+   +#+           #
#   Created: 0025/12/20 00:17:22 by ccavalca            #+#    #+#             #
#   Updated: 2026/01/06 20:28:17 by ccavalca           ###   ########.fr       #
#                                                                              #
# **************************************************************************** #

# ============================================================================
# PROGRAM
# ============================================================================

NAME		=	philo
NAME_BONUS	=	philo_bonus

MAKEFLAGS	+=	--no-print-directory

# ============================================================================
# COMPILER & FLAGS
# ============================================================================

CC			=	gcc
CFLAGS		=	-Wall -Wextra -Werror -pthread
CFLAGS		+=	-I./includes -I./libft/inc -I./gnl -I./libft/ft_printf/inc
CFLAGS_BONUS	=	-Wall -Wextra -Werror -pthread
CFLAGS_BONUS	+=	-I./bonus/includes -I./libft/inc -I./gnl -I./libft/ft_printf/inc
DEBUG_FLAGS	=	-g3 -DDEBUG
CFLAGS_OPT	=	-O2 -funroll-loops
LIBS		=	-L./libft -lft -pthread

# ============================================================================
# DIRECTORIES
# ============================================================================

SRC_DIR		=	src/
INC_DIR		=	includes/
OBJ_DIR		=	obj/
LIBFT_DIR	=	libft/
LIBFT_MAKE	:=	$(MAKE) -C $(LIBFT_DIR) --silent

BONUS_SRC_DIR	=	bonus/src/
BONUS_INC_DIR	=	bonus/includes/
BONUS_OBJ_DIR	=	obj/bonus/

# ============================================================================
# FILES
# ============================================================================

SRC_FILES	=	main.c \
				utils.c \
				validation.c \
				cleanup_and_error.c \
				philosopher.c \
				routines.c \
				monitor.c \
				output.c \
				time.c

OBJ_FILES	=	$(SRC_FILES:.c=.o)
OBJS		=	$(addprefix $(OBJ_DIR), $(OBJ_FILES))
LIBFT_A		= 	$(LIBFT_DIR)libft.a

# Bonus files
BONUS_SRC_FILES	=	main_bonus.c \
					utils_bonus.c \
					routines_bonus.c \
					monitor_bonus.c

# Reused from mandatory (compiled with bonus includes)
REUSED_FILES	=	philosopher.c \
					output.c \
					time.c \
					cleanup_and_error.c

BONUS_OBJ_FILES	=	$(BONUS_SRC_FILES:.c=.o) $(REUSED_FILES:.c=.o)
BONUS_OBJS		=	$(addprefix $(BONUS_OBJ_DIR), $(BONUS_OBJ_FILES))

# ============================================================================
# RULES
# ============================================================================

.PHONY: all clean fclean re debug help

all: $(NAME)

$(NAME): $(OBJS) $(LIBFT_A)
	@$(CC) $(CFLAGS) -o $(NAME) $(OBJS) $(LIBS)
	@echo "✓ $(NAME) compiled successfully"

# bonus: $(NAME_BONUS)

# $(NAME_BONUS): $(BONUS_OBJS) $(LIBFT_A)
# 	@$(CC) $(CFLAGS_BONUS) -o $(NAME_BONUS) $(BONUS_OBJS) $(LIBS)
# 	@echo "✓ $(NAME_BONUS) compiled successfully"

$(LIBFT_A):
	@$(LIBFT_MAKE)
	@echo "✓ libft compiled"

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	@mkdir -p $(OBJ_DIR)
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "✓ Compiling $<"

$(BONUS_OBJ_DIR)%.o: $(BONUS_SRC_DIR)%.c
	@mkdir -p $(BONUS_OBJ_DIR)
	@$(CC) $(CFLAGS_BONUS) -c $< -o $@
	@echo "✓ Compiling [BONUS] $<"

$(BONUS_OBJ_DIR)%.o: $(SRC_DIR)%.c
	@mkdir -p $(BONUS_OBJ_DIR)
	@$(CC) $(CFLAGS_BONUS) -c $< -o $@
	@echo "✓ Compiling [REUSED] $<"

debug: CFLAGS += $(DEBUG_FLAGS)
debug: clean all
	@echo "✓ Debug build complete"

release: CFLAGS += $(CFLAGS_OPT)
release: clean all
	@echo "✓ Release build complete"

clean:
	@rm -rf $(OBJ_DIR)
	@rm -rf $(BONUS_OBJ_DIR)
	@$(LIBFT_MAKE) clean
	@echo "✓ Object files cleaned"

fclean: clean
	@rm -f $(NAME) $(NAME_BONUS)
	@$(LIBFT_MAKE) fclean
	@echo "✓ All files cleaned"

re: fclean all

# ============================================================================
# ADDITIONAL RULES
# ============================================================================

run: all
	@./$(NAME)

valgrind: debug
	@valgrind --leak-check=full --show-leak-kinds=all \
		--track-origins=yes ./$(NAME)

norm:
	@norminette $(SRC_DIR) $(INC_DIR)
	@echo "✓ Norminette check done"

help:
	@echo "Available targets:"
	@echo "  make all      - Build the project"
	@echo "  make clean    - Remove object files"
	@echo "  make fclean   - Remove all generated files"
	@echo "  make re       - Rebuild everything"
	@echo "  make debug    - Build with debug symbols"
	@echo "  make release  - Build optimized release"
	@echo "  make run      - Build and run"
	@echo "  make valgrind - Run with valgrind"
	@echo "  make norm     - Check norminette"
