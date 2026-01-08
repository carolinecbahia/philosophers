/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main_bonus.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/01/06 16:57:23 by ccavalca          #+#    #+#             */
/*   Updated: 2026/01/06 20:23:09 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers_bonus.h"

static int	main_loop(t_table *table)
{
	pthread_t	monitor;
	int			i;

	table->start = get_time_ms();
	table->simulation = 1;
	i = 0;
	while (i < table->num_philos)
	{
		pthread_create(&table->philo[i].thread, NULL,
			philo_routine, &table->philo[i]);
		i++;
	}
	pthread_create(&monitor, NULL, monitor_routine, table);
	pthread_join(monitor, NULL);
	i = 0;
	while (i < table->num_philos)
	{
		pthread_join(table->philo[i].thread, NULL);
		i++;
	}
	return (0);
}

static t_table	*init_program(int argc, char **argv)
{
	t_table	*table;

	table = malloc(sizeof(t_table));
	if (!table)
	{
		error_exit("Malloc failed\n");
		return (NULL);
	}
	if (parser_bonus(argc, argv, table))
	{
		free(table);
		error_exit("Parser failed\n");
		return (NULL);
	}
	if (init_table(table))
	{
		cleanup(table);
		return (NULL);
	}
	return (table);
}

int	main(int argc, char **argv)
{
	t_table	*table;

	if (validate_args_bonus(argc, argv))
	{
		error_exit("Invalid args\n");
		return (1);
	}
	table = init_program(argc, argv);
	if (!table)
		return (1);
	main_loop(table);
	cleanup(table);
	return (0);
}