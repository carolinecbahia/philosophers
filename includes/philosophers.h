/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   philosophers.h                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/20 00:13:21 by ccavalca          #+#    #+#             */
/*   Updated: 2025/12/22 15:44:44 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PHILOSOPHERS_H
# define PHILOSOPHERS_H

/* ========================================================================
** INCLUDES
** ======================================================================== */

# include <string.h>         // memset
# include <stdio.h>          // printf
# include <stdlib.h>         // malloc, free
# include <unistd.h>         // write, usleep
# include <sys/time.h>       // gettimeofday
# include <pthread.h>        // Todas as pthread_*

/* ========================================================================
** DEFINES & CONSTANTS
** ======================================================================== */

# define SUCCESS 0
# define FAILURE -1
# define TRUE 1
# define FALSE 0

/* ========================================================================
** STRUCTURES
** ======================================================================== */

typedef struct s_philo
{
	int				id;
	pthread_t		thread;
	pthread_mutex_t	*left;
	pthread_mutex_t	*right;
	long			last_meal;
}	t_philo;

typedef struct s_data
{
	int		num_philos;
	long	time_to_die;
	long	time_to_eat;
	long	time_to_sleep;
	long		start;
	int				min_meals;
	int				simulation;
	pthread_mutex_t	*forks;
	pthread_mutex_t	print_mutex;
	t_philo			*philo;
}	t_data;

/* ========================================================================
** FUNCTION PROTOTYPES
** ======================================================================== */

/* Initialization functions */
t_data	*init_data(void);
void	free_data(t_data *data);

/* Core functions */
int		process_data(t_data *data);
int		validate_input(const char *input);

/* Utility functions */
char	*my_function(const char *param1, int param2);

#endif