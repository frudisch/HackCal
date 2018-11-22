package com.senacor.hacking.days.event.service.handler;

import com.senacor.hacking.days.event.service.handler.response.Event;
import com.senacor.hacking.days.event.service.service.EventService;
import io.helidon.webserver.Handler;
import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerRequest;
import io.helidon.webserver.ServerResponse;
import io.helidon.webserver.Service;
import io.helidon.webserver.json.JsonSupport;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Answers;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.json.Json;
import javax.json.JsonObject;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoMoreInteractions;
import static org.mockito.Mockito.when;

public class EventHandlerTest {

    @Mock
    private EventService eventService;

    @InjectMocks
    private EventHandler uut;

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    private ServerRequest serverRequest;

    @Mock
    private ServerResponse serverResponse;

    @Mock
    private Routing.Rules rules;


    @BeforeEach
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    @DisplayName("Test a successful event creation request")
    public void testSuccessfulEventCreation() {
        JsonObject testJson = Json.createObjectBuilder()
                .add("name", "test-name")
                .add("date", LocalDateTime.of(2018, 11, 21, 12, 12).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .add("description", "test-description")
                .build();

        Event testEvent = Event.builder()
                .name("test-name")
                .uuid(UUID.fromString("7ad93e43-3537-473b-8ff8-99b16895c66d"))
                .description("test-description")
                .date(LocalDateTime.of(2018, 11, 21, 12, 12))
                .build();

        when(eventService.createEvent(eq(Event.builder()
                .name("test-name")
                .description("test-description")
                .date(LocalDateTime.of(2018, 11, 21, 12, 12))
                .build()))).thenReturn(testEvent);

        uut.createEvent(serverRequest, serverResponse, testJson);

        verify(serverResponse, times(1)).send(eq(Json.createObjectBuilder()
                .add("name", "test-name")
                .add("date", LocalDateTime.of(2018, 11, 21, 12, 12).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .add("description", "test-description")
                .add("uuid", "7ad93e43-3537-473b-8ff8-99b16895c66d")
                .build()));
    }

    @Test
    @DisplayName("Test a successful event update request")
    public void testSuccessfulEventUpdate() {
        JsonObject testJson = Json.createObjectBuilder()
                .add("name", "test-update")
                .add("date", LocalDateTime.of(2018, 11, 21, 12, 12).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .add("description", "test-description")
                .build();

        Event testEvent = Event.builder()
                .name("test-update")
                .uuid(UUID.fromString("7ad93e43-3537-473b-8ff8-99b16895c66d"))
                .description("test-description")
                .date(LocalDateTime.of(2018, 11, 21, 12, 12))
                .build();

        when(eventService.updateEvent(eq(UUID.fromString("7ad93e43-3537-473b-8ff8-99b16895c66d")), eq(Event.builder()
                .name("test-update")
                .description("test-description")
                .date(LocalDateTime.of(2018, 11, 21, 12, 12))
                .build()))).thenReturn(testEvent);

        when(serverRequest.path().param(eq("id"))).thenReturn("7ad93e43-3537-473b-8ff8-99b16895c66d");

        uut.updateEvent(serverRequest, serverResponse, testJson);

        verify(serverResponse, times(1)).send(eq(Json.createObjectBuilder()
                .add("name", "test-update")
                .add("date", LocalDateTime.of(2018, 11, 21, 12, 12).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .add("description", "test-description")
                .add("uuid", "7ad93e43-3537-473b-8ff8-99b16895c66d")
                .build()));
    }

    @Test
    @DisplayName("Test a successful event delete request")
    public void testSuccessfulEventDelete() {
        when(serverRequest.path().param(eq("id"))).thenReturn("7ad93e43-3537-473b-8ff8-99b16895c66d");

        uut.deleteEvent(serverRequest, serverResponse);

        verify(eventService, times(1)).deleteEvent(eq(UUID.fromString("7ad93e43-3537-473b-8ff8-99b16895c66d")));
        verify(serverResponse, times(1)).send();
    }

    @Test
    @DisplayName("Test a successful event selection request by the event-id")
    public void testSuccessfulEventSelection() {
        Event testEvent = Event.builder()
                .name("test-name")
                .uuid(UUID.fromString("7ad93e43-3537-473b-8ff8-99b16895c66d"))
                .description("test-description")
                .date(LocalDateTime.of(2018, 11, 21, 12, 12))
                .build();

        when(serverRequest.path().param(eq("id"))).thenReturn("7ad93e43-3537-473b-8ff8-99b16895c66d");

        when(eventService.getEventById(eq(UUID.fromString("7ad93e43-3537-473b-8ff8-99b16895c66d")))).thenReturn(testEvent);

        uut.getEventById(serverRequest, serverResponse);

        verify(serverResponse, times(1)).send(eq(Json.createObjectBuilder()
                .add("name", "test-name")
                .add("date", LocalDateTime.of(2018, 11, 21, 12, 12).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .add("description", "test-description")
                .add("uuid", "7ad93e43-3537-473b-8ff8-99b16895c66d")
                .build()));
    }

    @Test
    @DisplayName("Test a successful complete event list selection request")
    public void testSuccessfulAllEventSelection() {
        Event testEvent = Event.builder()
                .name("test-name")
                .uuid(UUID.fromString("7ad93e43-3537-473b-8ff8-99b16895c66d"))
                .description("test-description")
                .date(LocalDateTime.of(2018, 11, 21, 12, 12))
                .build();

        when(eventService.getAllEvents()).thenReturn(Collections.singletonList(testEvent));

        uut.getAllEvents(serverRequest, serverResponse);

        verify(serverResponse, times(1)).send(eq(Collections.singletonList(Json.createObjectBuilder()
                .add("name", "test-name")
                .add("date", LocalDateTime.of(2018, 11, 21, 12, 12).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))
                .add("description", "test-description")
                .add("uuid", "7ad93e43-3537-473b-8ff8-99b16895c66d")
                .build())));
    }

    @Test
    @DisplayName("Test the correct route definition")
    public void testRouteDefinition() {
        when(rules.register(any(Service.class))).thenReturn(rules);
        when(rules.get(anyString(), any(Handler.class))).thenReturn(rules);
        when(rules.delete(anyString(), any(Handler.class))).thenReturn(rules);
        when(rules.post(anyString(), any(Handler.class))).thenReturn(rules);
        when(rules.put(anyString(), any(Handler.class))).thenReturn(rules);

        uut.update(rules);

        verify(rules, times(1)).register(eq(JsonSupport.get()));
        verify(rules, times(1)).get(eq("/"), any());
        verify(rules, times(1)).get(eq("/{id}"), any());
        verify(rules, times(1)).post(eq("/"), any());
        verify(rules, times(1)).delete(eq("/{id}"), any());
        verify(rules, times(1)).put(eq("/{id}"), any());
        verifyNoMoreInteractions(rules);
    }

}
