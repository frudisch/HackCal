package com.senacor.hacking.days.event.service.repository.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Event {

    private UUID id;

    private String name;

    private LocalDateTime date;

    private String description;
}
