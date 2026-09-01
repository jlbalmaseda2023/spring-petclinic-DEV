package org.springframework.samples.petclinic.dashboard;

import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class SprintService {

	public SprintMetrics getSprintMetrics() {
		// Simulación de datos de Jira para el sprint activo
		List<SprintTicket> tickets = Arrays.asList(
				new SprintTicket("PETCLINIC-1", "Implementar login", "Done", "Alice"),
				new SprintTicket("PETCLINIC-2", "Crear perfil de usuario", "In Progress", "Bob"),
				new SprintTicket("PETCLINIC-3", "Configurar base de datos", "To Do", "Charlie"),
				new SprintTicket("PETCLINIC-4", "Mostrar dashboard de metricas", "In Progress", "Alice"));

		SprintMetrics metrics = new SprintMetrics();
		metrics.setActiveSprintName("Sprint 1 - PetClinic");
		metrics.setTickets(tickets);
		metrics.setTotalIssues(tickets.size());

		int toDo = 0;
		int inProgress = 0;
		int done = 0;

		for (SprintTicket ticket : tickets) {
			if ("To Do".equals(ticket.getStatus())) {
				toDo++;
			}
			else if ("In Progress".equals(ticket.getStatus())) {
				inProgress++;
			}
			else if ("Done".equals(ticket.getStatus())) {
				done++;
			}
		}

		metrics.setToDo(toDo);
		metrics.setInProgress(inProgress);
		metrics.setDone(done);

		return metrics;
	}

}
