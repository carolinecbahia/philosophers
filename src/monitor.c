/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   monitor.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/30 07:30:00 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 20:50:43 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

int	check_death(t_table *table)
{
	int		i;
	long	now;
	long	elapsed;

	i = 0;
	while (i < table->num_philos)
	{
		now = get_time_ms();
		pthread_mutex_lock(&table->data_mutex);
		elapsed = now - table->philo[i].last_meal;
		pthread_mutex_unlock(&table->data_mutex);
		if (elapsed > table->time_to_die)
		{
			print_death(table, table->philo[i].id);
			return (1);
		}
		i++;
	}
	return (0);
}

static void	print_all_ate(t_table *table)
{
	long	timestamp;

	timestamp = get_elapsed_time_ms(table->start);
	pthread_mutex_lock(&table->print_mutex);
	printf("%ld All philosophers have eaten %d times\n",
		timestamp, table->meals_required);
	pthread_mutex_unlock(&table->print_mutex);
}

int	check_all_ate(t_table *table)
{
	int	i;

	if (table->meals_required == -1)
		return (0);
	pthread_mutex_lock(&table->data_mutex);
	i = 0;
	while (i < table->num_philos)
	{
		if (table->philo[i].meals_eaten < table->meals_required)
		{
			pthread_mutex_unlock(&table->data_mutex);
			return (0);
		}
		i++;
	}
	print_all_ate(table);
	pthread_mutex_unlock(&table->data_mutex);
	return (1);
}

void	*monitor_routine(void *arg)
{
	t_table	*table;
	int		running;

	table = (t_table *)arg;
	while (1)
	{
		pthread_mutex_lock(&table->data_mutex);
		running = table->simulation;
		pthread_mutex_unlock(&table->data_mutex);
		if (running == 0)
			break ;
		if (check_death(table) || check_all_ate(table))
		{
			pthread_mutex_lock(&table->data_mutex);
			table->simulation = 0;
			pthread_mutex_unlock(&table->data_mutex);
			break ;
		}
		usleep(1000);
	}
	return (NULL);
}
