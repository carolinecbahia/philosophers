# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ccavalca <ccavalca@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/12 19:09:24 by ccavalca          #+#    #+#              #
#    Updated: 2025/12/14 14:43:56 by ccavalca         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = libft.a

FT_PRINTF_DIR = ft_printf/src/bonus/
SRC_DIR = src/

LIBFT_SRC	=	$(SRC_DIR)mandatory/ft_atoi.c	\
				$(SRC_DIR)addtional/ft_atol.c \
 				$(SRC_DIR)mandatory/ft_bzero.c	\
				$(SRC_DIR)mandatory/ft_calloc.c	\
				$(SRC_DIR)mandatory/ft_isalnum.c	\
				$(SRC_DIR)mandatory/ft_isalpha.c	\
				$(SRC_DIR)mandatory/ft_isascii.c	\
				$(SRC_DIR)mandatory/ft_isdigit.c	\
				$(SRC_DIR)mandatory/ft_isprint.c	\
				$(SRC_DIR)mandatory/ft_memchr.c	\
				$(SRC_DIR)mandatory/ft_memcmp.c	\
				$(SRC_DIR)mandatory/ft_memcpy.c	\
				$(SRC_DIR)mandatory/ft_memmove.c	\
				$(SRC_DIR)mandatory/ft_memset.c	\
				$(SRC_DIR)mandatory/ft_strchr.c	\
				$(SRC_DIR)mandatory/ft_strdup.c	\
				$(SRC_DIR)mandatory/ft_strlcat.c	\
				$(SRC_DIR)mandatory/ft_strlcpy.c	\
				$(SRC_DIR)mandatory/ft_strlen.c	\
				$(SRC_DIR)mandatory/ft_strncmp.c	\
				$(SRC_DIR)mandatory/ft_strnstr.c	\
				$(SRC_DIR)mandatory/ft_strrchr.c	\
				$(SRC_DIR)mandatory/ft_tolower.c	\
				$(SRC_DIR)mandatory/ft_toupper.c	\
				$(SRC_DIR)mandatory/ft_substr.c	\
				$(SRC_DIR)mandatory/ft_strjoin.c	\
				$(SRC_DIR)mandatory/ft_strtrim.c	\
				$(SRC_DIR)mandatory/ft_split.c	\
				$(SRC_DIR)mandatory/ft_itoa.c	\
				$(SRC_DIR)mandatory/ft_strmapi.c	\
				$(SRC_DIR)mandatory/ft_striteri.c	\
				$(SRC_DIR)mandatory/ft_putchar_fd.c	\
				$(SRC_DIR)mandatory/ft_putstr_fd.c	\
				$(SRC_DIR)mandatory/ft_putendl_fd.c	\
				$(SRC_DIR)mandatory/ft_putnbr_fd.c	\

PRINTF_SRC = $(FT_PRINTF_DIR)ft_printf.c \
			$(FT_PRINTF_DIR)ft_printf_utils.c \
			$(FT_PRINTF_DIR)../specifiers_chars.c \
			$(FT_PRINTF_DIR)../specifiers_nbrs.c \
			 
OBJS = $(LIBFT_SRC:.c=.o) $(PRINTF_SRC:.c=.o)

CC = gcc
CFLAGS = -Wall -Werror -Wextra -I./inc -I./ft_printf/inc -I./gnl
RM = rm -rf
AR = ar crs

$(NAME): $(OBJS)
	$(AR) $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

all: $(NAME)

clean:
	$(RM) $(OBJS)

fclean:	clean
	$(RM) $(NAME)		

re:	fclean all

.PHONY:	all clean fclean re