DROP TABLE IF EXISTS p1.patients;
DROP TABLE IF EXISTS p1.dentists;
DROP TABLE IF EXISTS p1.treatments;
DROP TABLE IF EXISTS p1.appointments;
DROP TABLE IF EXISTS p1.appointment_treatment;
DROP TABLE IF EXISTS p1.treatment_dentist;
DROP TABLE IF EXISTS p1.payments;

CREATE TABLE p1.patients (
    patient_id INT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    CONSTRAINT pk_patients PRIMARY KEY (patient_id)
);

CREATE TABLE p1.dentists (
    dentist_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    CONSTRAINT pk_dentists PRIMARY KEY (dentist_id)
);

CREATE TABLE p1.treatments (
    treatment_id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    CONSTRAINT pk_treatments PRIMARY KEY (treatment_id)
);

CREATE TABLE p1.appointments (
    appointment_id INT GENERATED ALWAYS AS IDENTITY,
    patient_id INT NOT NULL,
    dentist_id SMALLINT NOT NULL,
    appointment_date TIMESTAMP NOT NULL CHECK (
        appointment_date BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + INTERVAL '6 months'
    ),
    duration INTERVAL NOT NULL CHECK (duration >= INTERVAL '30 minutes' AND duration <= INTERVAL '3 hours'),
    status VARCHAR(20) NOT NULL CHECK (status IN ('Scheduled', 'Completed', 'Cancelled')),
    CONSTRAINT pk_appointments PRIMARY KEY (appointment_id),
    CONSTRAINT fk_appointments_patients FOREIGN KEY (patient_id) 
        REFERENCES p1.patients(patient_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_appointments_dentists FOREIGN KEY (dentist_id) 
        REFERENCES p1.dentists(dentist_id) 
        ON DELETE CASCADE
);

CREATE TABLE p1.appointment_treatment (
    appointment_id INT NOT NULL,
    treatment_id INT NOT NULL,
    cost DECIMAL(6,2) NOT NULL,
    CONSTRAINT pk_appointment_treatment PRIMARY KEY (appointment_id, treatment_id),
    CONSTRAINT fk_appointment_treatment FOREIGN KEY (appointment_id)
        REFERENCES p1.appointments(appointment_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_appointment_treatment_treatment FOREIGN KEY (treatment_id)
        REFERENCES p1.treatments(treatment_id) 
        ON DELETE CASCADE
);

CREATE TABLE p1.treatment_dentist (
    dentist_id SMALLINT NOT NULL,
    treatment_id INT NOT NULL,
    CONSTRAINT pk_treatment_dentist PRIMARY KEY (dentist_id, treatment_id),
    CONSTRAINT fk_treatment_dentist_dentist FOREIGN KEY (dentist_id)
        REFERENCES p1.dentists(dentist_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_treatment_dentist_treatment FOREIGN KEY (treatment_id)
        REFERENCES p1.treatments(treatment_id) 
        ON DELETE CASCADE
);

CREATE TABLE p1.payments (
    payment_id INT GENERATED ALWAYS AS IDENTITY,
    patient_id INT NOT NULL,
    amount DECIMAL(6,2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('Cash', 'Credit Card', 'Debit Card', 'Insurance')),
    CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_patient FOREIGN KEY (patient_id)
        REFERENCES p1.patients(patient_id)
        ON DELETE CASCADE
);


INSERT INTO p1.patients (first_name, last_name, date_of_birth, phone, email)
VALUES 
('John', 'Doe', '1990-05-15', '123-456-7890', 'john.doe@example.com'),
('Jane', 'Smith', '1985-08-22', '987-654-3210', 'jane.smith@example.com');

INSERT INTO p1.dentists (first_name, last_name, phone, email)
VALUES 
('Dr. Emily', 'Brown', '555-111-2222', 'emily.brown@dentalclinic.com'),
('Dr. Michael', 'Clark', '555-333-4444', 'michael.clark@dentalclinic.com');

INSERT INTO p1.treatments (name, description)
VALUES 
('Teeth Cleaning', 'Professional dental cleaning to remove plaque and tartar.'),
('Root Canal', 'Treatment to repair and save a badly damaged tooth.');

INSERT INTO p1.appointments (patient_id, dentist_id, appointment_date, duration, status)
VALUES 
(1, 1, CURRENT_TIMESTAMP + INTERVAL '1 day', INTERVAL '1 hour', 'Scheduled'),
(2, 2, CURRENT_TIMESTAMP + INTERVAL '2 days', INTERVAL '45 minutes', 'Scheduled');

INSERT INTO p1.appointment_treatment (appointment_id, treatment_id, cost)
VALUES 
(1, 1, 100.00),
(2, 2, 500.00);

INSERT INTO p1.treatment_dentist (dentist_id, treatment_id)
VALUES 
(1, 1),
(2, 2);

INSERT INTO p1.payments (patient_id, amount, payment_method)
VALUES 
(1, 100.00, 'Credit Card'),
(2, 500.00, 'Insurance');

SELECT * FROM p1.patients;
SELECT * FROM p1.dentists;
SELECT * FROM p1.treatments;
SELECT * FROM p1.appointments;
SELECT * FROM p1.appointment_treatment;
SELECT * FROM p1.treatment_dentist;
SELECT * FROM p1.payments;