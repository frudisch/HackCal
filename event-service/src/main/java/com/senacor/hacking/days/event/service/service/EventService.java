package com.senacor.hacking.days.event.service.service;

import com.senacor.hacking.days.event.service.handler.port.Event;
import com.senacor.hacking.days.event.service.repository.EventRepository;
import com.senacor.hacking.days.event.service.repository.MongoDB;
import lombok.AllArgsConstructor;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@AllArgsConstructor
public class EventService {

    private EventRepository eventRepository;

    public void deleteEvent(UUID uuid) {
        eventRepository.deleteEvent(uuid);
    }

    public Event updateEvent(UUID uuid, Event event) {
        return map(eventRepository.findAndReplaceEvent(uuid, map(event)));
    }

    public Event createEvent(Event event) {
        event.setUuid(UUID.randomUUID());
        eventRepository.insertEvent(map(event));
        return event;
    }

    public List<Event> getAllEvents() {
        return eventRepository.selectAllEvents().stream().map(this::map).collect(Collectors.toList());
    }

    public Event getEventById(UUID uuid) {
        return map(eventRepository.selectEventByUuid(uuid));
    }

    private Event map(com.senacor.hacking.days.event.service.repository.domain.Event event) {
        return Event.builder()
                .date(event.getDate())
                .name(event.getName())
                .uuid(event.getId())
                .description(event.getDescription())
                .build();
    }

    private com.senacor.hacking.days.event.service.repository.domain.Event map(Event event) {
        return com.senacor.hacking.days.event.service.repository.domain.Event.builder()
                .date(event.getDate())
                .name(event.getName())
                .id(event.getUuid())
                .description(event.getDescription())
                .build();
    }
}
