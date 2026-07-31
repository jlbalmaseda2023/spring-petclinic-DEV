package org.springframework.samples.petclinic.appointment;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;
import org.springframework.boot.jpa.test.autoconfigure.TestEntityManager;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
class AppointmentRepositoryTests {

	@Autowired
	private AppointmentRepository appointmentRepository;

	@Autowired
	private TestEntityManager entityManager;

	@Test
	void testSaveAndFindById() {
		Appointment appointment = new Appointment();
		appointment.setVetId(1);
		appointment.setPetId(1);
		appointment.setOwnerId(1);
		appointment.setSlot(LocalDateTime.of(2026, 8, 15, 10, 0));
		appointment.setVisitType("CHECKUP");
		appointment.setStatus(AppointmentStatus.PENDING);
		Appointment saved = entityManager.persistAndFlush(appointment);

		Optional<Appointment> found = appointmentRepository.findById(saved.getId());

		assertThat(found).isPresent();
		assertThat(found.get().getVetId()).isEqualTo(1);
		assertThat(found.get().getStatus()).isEqualTo(AppointmentStatus.PENDING);
	}

	@Test
	void testFindByVetIdAndSlot() {
		LocalDateTime slot = LocalDateTime.of(2026, 8, 15, 10, 0);
		Appointment appointment = new Appointment();
		appointment.setVetId(1);
		appointment.setPetId(1);
		appointment.setOwnerId(1);
		appointment.setSlot(slot);
		appointment.setVisitType("CHECKUP");
		appointment.setStatus(AppointmentStatus.PENDING);
		entityManager.persistAndFlush(appointment);

		List<Appointment> found = appointmentRepository.findByVetIdAndSlot(1, slot);

		assertThat(found).hasSize(1);
		assertThat(found.get(0).getVisitType()).isEqualTo("CHECKUP");
	}

	@Test
	void testFindByVetIdAndStatus() {
		Appointment a1 = new Appointment();
		a1.setVetId(1);
		a1.setPetId(1);
		a1.setOwnerId(1);
		a1.setSlot(LocalDateTime.of(2026, 8, 15, 10, 0));
		a1.setVisitType("CHECKUP");
		a1.setStatus(AppointmentStatus.PENDING);
		entityManager.persistAndFlush(a1);

		Appointment a2 = new Appointment();
		a2.setVetId(1);
		a2.setPetId(2);
		a2.setOwnerId(2);
		a2.setSlot(LocalDateTime.of(2026, 8, 15, 11, 0));
		a2.setVisitType("VACCINATION");
		a2.setStatus(AppointmentStatus.CONFIRMED);
		entityManager.persistAndFlush(a2);

		List<Appointment> found = appointmentRepository.findByVetIdAndStatus(1, AppointmentStatus.PENDING);

		assertThat(found).hasSize(1);
		assertThat(found.get(0).getStatus()).isEqualTo(AppointmentStatus.PENDING);
	}

	@Test
	void testFindByOwnerId() {
		Appointment a1 = new Appointment();
		a1.setVetId(1);
		a1.setPetId(1);
		a1.setOwnerId(1);
		a1.setSlot(LocalDateTime.of(2026, 8, 15, 10, 0));
		a1.setVisitType("CHECKUP");
		a1.setStatus(AppointmentStatus.PENDING);
		entityManager.persistAndFlush(a1);

		Appointment a2 = new Appointment();
		a2.setVetId(2);
		a2.setPetId(2);
		a2.setOwnerId(1);
		a2.setSlot(LocalDateTime.of(2026, 8, 16, 10, 0));
		a2.setVisitType("VACCINATION");
		a2.setStatus(AppointmentStatus.CONFIRMED);
		entityManager.persistAndFlush(a2);

		List<Appointment> found = appointmentRepository.findByOwnerId(1);

		assertThat(found).hasSize(2);
	}

	@Test
	void testFindByStatus() {
		Appointment a1 = new Appointment();
		a1.setVetId(1);
		a1.setPetId(1);
		a1.setOwnerId(1);
		a1.setSlot(LocalDateTime.of(2026, 8, 15, 10, 0));
		a1.setVisitType("CHECKUP");
		a1.setStatus(AppointmentStatus.PENDING);
		entityManager.persistAndFlush(a1);

		Appointment a2 = new Appointment();
		a2.setVetId(2);
		a2.setPetId(2);
		a2.setOwnerId(2);
		a2.setSlot(LocalDateTime.of(2026, 8, 16, 10, 0));
		a2.setVisitType("VACCINATION");
		a2.setStatus(AppointmentStatus.CANCELLED);
		entityManager.persistAndFlush(a2);

		List<Appointment> found = appointmentRepository.findByStatus(AppointmentStatus.CANCELLED);

		assertThat(found).hasSize(1);
		assertThat(found.get(0).getStatus()).isEqualTo(AppointmentStatus.CANCELLED);
	}

}
