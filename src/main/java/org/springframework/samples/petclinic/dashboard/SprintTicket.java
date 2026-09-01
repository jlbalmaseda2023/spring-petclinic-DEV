package org.springframework.samples.petclinic.dashboard;

public class SprintTicket {

	private String id;

	private String summary;

	private String status;

	private String assignee;

	public SprintTicket() {
	}

	public SprintTicket(String id, String summary, String status, String assignee) {
		this.id = id;
		this.summary = summary;
		this.status = status;
		this.assignee = assignee;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

}
