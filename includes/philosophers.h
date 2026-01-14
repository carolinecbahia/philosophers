/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   philosophers.h                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/20 00:13:21 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 19:01:40 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PHILOSOPHERS_H
# define PHILOSOPHERS_H

/* ========================================================================
** INCLUDES
** ======================================================================== */

# include "types.h"			// structs, enums
# include "libft.h"			// libft expanded
# include <string.h>		// memset
# include <stdio.h>			// printf
# include <stdlib.h>		// malloc, free
# include <unistd.h>		// write, usleep
# include <sys/time.h>		// gettimeofday
# include <pthread.h>		// Todas as pthread_*

/* ========================================================================
** DEFINES & CONSTANTS
** ======================================================================== */

# define SUCCESS 0
# define FAILURE -1
# define TRUE 1
# define FALSE 0

/* ========================================================================
** FUNCTION PROTOTYPES
** ======================================================================== */

/* Main */
int		main(int argc, char **argv);

/* Philosopher functions (philosopher.c and routines.c) */
void	*philo_routine(void *arg);
void	take_forks(t_philo *philo, t_table *table);
void	drop_forks(t_philo *philo);
void	philo_eat(t_philo *philo, t_table *table);
void	philo_sleep(t_table *table, int philo_id);
void	philo_think(t_table *table, int philo_id);

/* Monitor functions (monitor.c) */
void	*monitor_routine(void *arg);
int		check_death(t_table *table);
int		check_all_ate(t_table *table);

/* Output functions (output.c) */
void	print_status(t_table *table, int philo_id, char *status);
void	print_death(t_table *table, int philo_id);

/* Time functions (time.c) */
long	get_time_ms(void);
long	get_elapsed_time_ms(long s_time);
int		ft_usleep(long msecs);

/* Utils functions (utils.c) */
int		validate_args(int ac, char **av);
int		parser(int ac, char **av, t_table *table);
int		init_table(t_table *table);

/* Cleanup and error functions (cleanup_and_error.c) */
void	return_error(char *error_msg);
void	cleanup(t_table *table);
void	destroy_mutexes(t_table *table);
void	error_exit(char *error_msg);

#endif