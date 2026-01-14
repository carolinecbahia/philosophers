/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   output.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/30 07:30:00 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 17:00:26 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

void	print_status(t_table *table, int philo_id, char *status)
{
	long	timestamp;

	pthread_mutex_lock(&table->data_mutex);
	if (table->simulation == 0)
	{
		pthread_mutex_unlock(&table->data_mutex);
		return ;
	}
	pthread_mutex_unlock(&table->data_mutex);
	pthread_mutex_lock(&table->print_mutex);
	timestamp = get_elapsed_time_ms(table->start);
	printf("%ld %d %s\n", timestamp, philo_id, status);
	pthread_mutex_unlock(&table->print_mutex);
}

void	print_death(t_table *table, int philo_id)
{
	long	timestamp;

	timestamp = get_elapsed_time_ms(table->start);
	pthread_mutex_lock(&table->data_mutex);
	table->simulation = 0;
	pthread_mutex_unlock(&table->data_mutex);
	pthread_mutex_lock(&table->print_mutex);
	printf("%ld %d died\n", timestamp, philo_id);
	pthread_mutex_unlock(&table->print_mutex);
}
