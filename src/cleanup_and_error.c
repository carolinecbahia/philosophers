/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cleanup_and_error.c                                :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ccavalca <ccavalca@student.42sp.org.br>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/30 07:20:51 by ccavalca          #+#    #+#             */
/*   Updated: 2025/12/30 07:32:43 by ccavalca         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "philosophers.h"

void	return_error(char *error_msg)
{
	ft_printf("Error: %s\n", error_msg);
	return (1);
}

void	cleanup(t_table *table)
{

}

void	destroy_mutexes(t_table *table)
{

}
