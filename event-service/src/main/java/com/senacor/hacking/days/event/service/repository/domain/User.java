package com.senacor.hacking.days.event.service.repository.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class User {

    private UUID id;

    private String firstName;

    private String lastName;

    private List<UUID> attendingEvents = new ArrayList<>();
}
