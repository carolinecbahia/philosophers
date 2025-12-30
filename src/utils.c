/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/30 07:30:00 by ccavalca          #+#    #+#             */
/*   Updated: 2025/12/30 07:39:24 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

int validate_args(int ac, char **av)
{
	int i;

	if (ac != 5)
	{
		printf("Error: Invalid arguments\n");
		return (1);
	}
	i = 0;
	while (i <= ac)
	{
		if (!ft_isint(ft_atoi(av[i]))
	}
}

int parse_args(int ac, char **av, t_table *table)
{
	
}

int init_philos(t_table * table)
{
	
}
