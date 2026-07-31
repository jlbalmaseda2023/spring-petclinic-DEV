package org.springframework.samples.petclinic.appointment;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AppointmentAuditLogRepository extends JpaRepository<AppointmentAuditLog, Integer> {

	List<AppointmentAuditLog> findByAppointmentId(Integer appointmentId);

}
