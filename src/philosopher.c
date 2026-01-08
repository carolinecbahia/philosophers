/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   philosopher.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/30 07:30:00 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 20:50:43 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

static int	check_simulation(t_table *table)
{
	int	running;

	pthread_mutex_lock(&table->print_mutex);
	running = table->simulation;
	pthread_mutex_unlock(&table->print_mutex);
	return (running);
}

void	*philo_routine(void *arg)
{
	t_philo	*philo;
	t_table	*table;
	
	philo = (t_philo*)arg;
	table = philo->table;
	if (philo->id % 2 == 0)
		usleep(1000);
	while (check_simulation(table))
	{
		philo_think(table, philo->id);
		take_forks(philo, table);
		philo_eat(philo, table);
		drop_forks(philo);
		philo_sleep(table, philo->id);
	}
	return (NULL);
}

void	take_forks(t_philo *philo, t_table *table)
{
	if (table->num_philos == 1)
	{
		pthread_mutex_lock(philo->fork_left);
		print_status(table, philo->id, "has taken a fork");
		while (check_simulation(table))
			usleep(1000);
		pthread_mutex_unlock(philo->fork_left);
		return ;
	}
	if (philo->id % 2 == 0)
	{
		pthread_mutex_lock(philo->fork_right);
		print_status(table, philo->id, "has taken a fork");
		pthread_mutex_lock(philo->fork_left);
		print_status(table, philo->id, "has taken a fork");
	}
	else
	{
		pthread_mutex_lock(philo->fork_left);
		print_status(table, philo->id, "has taken a fork");
		pthread_mutex_lock(philo->fork_right);
		print_status(table, philo->id, "has taken a fork");
	}
}

void	drop_forks(t_philo *philo)
{
	pthread_mutex_unlock(philo->fork_left);
	pthread_mutex_unlock(philo->fork_right);
}
