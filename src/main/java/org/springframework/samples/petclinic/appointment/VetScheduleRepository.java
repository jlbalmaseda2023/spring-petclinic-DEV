package org.springframework.samples.petclinic.appointment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface VetScheduleRepository extends JpaRepository<VetSchedule, Integer> {

	List<VetSchedule> findByVetId(Integer vetId);

}
