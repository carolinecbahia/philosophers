/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cleanup_and_error.c                                :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/30 07:20:51 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 15:15:26 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

void	return_error(char *error_msg)
{
	ft_printf("Error: %s\n", error_msg);
}

void	cleanup(t_table *table)
{
    int	i;

    if (!table)
        return ;
    if (table->forks)
    {
        i = 0;
        while (i < table->num_philos)
        {
            pthread_mutex_destroy(&table->forks[i]);
            i++;
        }
        free(table->forks);
    }
    if (table->philo)
        free(table->philo);
    pthread_mutex_destroy(&table->print_mutex);
    free(table);
}

void	destroy_mutexes(t_table *table)
{
    int	i;

    if (!table || !table->forks)
        return ;
    i = 0;
    while (i < table->num_philos)
    {
        pthread_mutex_destroy(&table->forks[i]);
        i++;
    }
    pthread_mutex_destroy(&table->print_mutex);
}

void	error_exit(char *error_msg)
{
    ft_printf("Error: %s\n", error_msg);
}
