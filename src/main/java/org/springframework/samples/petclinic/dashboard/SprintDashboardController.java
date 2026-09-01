package org.springframework.samples.petclinic.dashboard;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SprintDashboardController {

	private final SprintService sprintService;

	public SprintDashboardController(SprintService sprintService) {
		this.sprintService = sprintService;
	}

	@GetMapping("/dashboard")
	public String showDashboard(Model model) {
		SprintMetrics metrics = sprintService.getSprintMetrics();
		model.addAttribute("metrics", metrics);
		return "dashboard/sprintDashboard";
	}

	@GetMapping("/api/dashboard")
	public @ResponseBody SprintMetrics getDashboardData() {
		return sprintService.getSprintMetrics();
	}

}
