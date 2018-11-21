package com.senacor.hacking.days.event.service.service;

import com.senacor.hacking.days.event.service.handler.response.Event;
import com.senacor.hacking.days.event.service.repository.MongoDB;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public class EventService {

    private MongoDB mongoDB;

    public EventService(MongoDB mongoDB) {
        this.mongoDB = mongoDB;
    }


    public void deleteEvent(UUID uuid) {
        mongoDB.deleteEvent(uuid);
    }

    public Event updateEvent(UUID uuid, Event event) {
        return map(mongoDB.findAndReplaceEvent(uuid, map(event)));
    }

    public Event createEvent(Event event) {
        event.setUuid(UUID.randomUUID());
        mongoDB.insertEvent(map(event));
        return event;
    }

    public List<Event> getAllEvents() {
        return mongoDB.selectAllEvents().stream().map(this::map).collect(Collectors.toList());
    }

    public Event getEventById(UUID uuid) {
        return map(mongoDB.selectEventByUuid(uuid));
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
