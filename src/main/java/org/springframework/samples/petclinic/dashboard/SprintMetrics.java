package org.springframework.samples.petclinic.dashboard;

import java.util.List;

public class SprintMetrics {

	private String activeSprintName;

	private int totalIssues;

	private int toDo;

	private int inProgress;

	private int done;

	private List<SprintTicket> tickets;

	public SprintMetrics() {
	}

	public String getActiveSprintName() {
		return activeSprintName;
	}

	public void setActiveSprintName(String activeSprintName) {
		this.activeSprintName = activeSprintName;
	}

	public int getTotalIssues() {
		return totalIssues;
	}

	public void setTotalIssues(int totalIssues) {
		this.totalIssues = totalIssues;
	}

	public int getToDo() {
		return toDo;
	}

	public void setToDo(int toDo) {
		this.toDo = toDo;
	}

	public int getInProgress() {
		return inProgress;
	}

	public void setInProgress(int inProgress) {
		this.inProgress = inProgress;
	}

	public int getDone() {
		return done;
	}

	public void setDone(int done) {
		this.done = done;
	}

	public List<SprintTicket> getTickets() {
		return tickets;
	}

	public void setTickets(List<SprintTicket> tickets) {
		this.tickets = tickets;
	}

}
