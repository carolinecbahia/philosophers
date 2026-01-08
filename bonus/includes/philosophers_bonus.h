/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   philosophers_bonus.h                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/01/06 16:57:50 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 20:27:52 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PHILOSOPHERS_BONUS_H
# define PHILOSOPHERS_BONUS_H

/* ========================================================================
** INCLUDES
** ======================================================================== */

# include "types_bonus.h"
# include "libft.h"
# include <string.h>
# include <stdio.h>
# include <stdlib.h>
# include <unistd.h>
# include <sys/time.h>
# include <pthread.h>

/* ========================================================================
** DEFINES & CONSTANTS
** ======================================================================== */

# define SUCCESS 0
# define FAILURE -1
# define TRUE 1
# define FALSE 0

/* ========================================================================
** FUNCTION PROTOTYPES - BONUS ONLY
** ======================================================================== */

/* Main (main_bonus.c) */
int		main(int argc, char **argv);

/* Utils (utils_bonus.c) */
int		validate_args_bonus(int ac, char **av);
int		parser_bonus(int ac, char **av, t_table *table);
int		init_table(t_table *table);

/* Routines (routines_bonus.c) */
void	philo_eat(t_philo *philo, t_table *table);

/* Monitor (monitor_bonus.c) */
void	*monitor_routine(void *arg);
int		check_death(t_table *table);
int		check_all_ate(t_table *table);

/* ========================================================================
** REUTILIZADAS DO MANDATORY (declarações para linking)
** ======================================================================== */

/* philosopher.c */
void	*philo_routine(void *arg);
void	take_forks(t_philo *philo, t_table *table);
void	drop_forks(t_philo *philo);

/* routines.c */
void	philo_sleep(t_table *table, int philo_id);
void	philo_think(t_table *table, int philo_id);

/* output.c */
void	print_status(t_table *table, int philo_id, char *status);
void	print_death(t_table *table, int philo_id);

/* time.c */
long	get_time_ms(void);
long	get_elapsed_time_ms(long start);
int		ft_usleep(long time_ms);

/* cleanup_and_error.c */
void	cleanup(t_table *table);
void	destroy_mutexes(t_table *table);
void	error_exit(char *msg);

#endif
