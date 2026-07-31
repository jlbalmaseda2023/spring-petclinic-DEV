package org.springframework.samples.petclinic.appointment;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AppointmentRepository extends JpaRepository<Appointment, Integer> {

	List<Appointment> findByVetIdAndSlot(Integer vetId, LocalDateTime slot);

	List<Appointment> findByVetIdAndStatus(Integer vetId, AppointmentStatus status);

	List<Appointment> findByOwnerId(Integer ownerId);

	List<Appointment> findByStatus(AppointmentStatus status);

	Optional<Appointment> findById(Integer id);

}
