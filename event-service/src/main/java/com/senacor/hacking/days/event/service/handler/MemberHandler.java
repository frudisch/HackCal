package com.senacor.hacking.days.event.service.handler;

import com.senacor.hacking.days.event.service.handler.port.EventMemberList;
import com.senacor.hacking.days.event.service.service.MemberService;
import io.helidon.webserver.Handler;
import io.helidon.webserver.Routing;
import io.helidon.webserver.ServerRequest;
import io.helidon.webserver.ServerResponse;
import io.helidon.webserver.Service;
import io.helidon.webserver.json.JsonSupport;
import lombok.AllArgsConstructor;
import lombok.Getter;

import javax.json.JsonObject;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Getter
@AllArgsConstructor
public class MemberHandler implements Service {

    private final MemberService memberService;

    @Override
    public void update(Routing.Rules rules) {
        rules
                .register(JsonSupport.get())
                .delete("/{id}", this::deleteMember)
                .get("/", this::getAllMembers)
                .post("/", Handler.of(JsonObject.class, this::addMember));
    }

    private void addMember(ServerRequest serverRequest, ServerResponse serverResponse, JsonObject jsonObject) {
        List<UUID> newMembers = new ArrayList<>();
        if (jsonObject.get("members") == null) {
            serverResponse.status(201).send();
            return;
        }
        jsonObject.getJsonArray("members").forEach(data -> newMembers.add(UUID.fromString(data.toString().replaceAll("\"", ""))));
        String eventId = serverRequest.path().absolute().param("eventId");
        memberService.addMembers(UUID.fromString(eventId), newMembers);
        serverResponse.status(201).send();
    }

    private void deleteMember(ServerRequest serverRequest, ServerResponse serverResponse) {
        String eventId = serverRequest.path().absolute().param("eventId");
        String userId = serverRequest.path().absolute().param("id");
        memberService.removeMember(UUID.fromString(eventId), UUID.fromString(userId));
        serverResponse.status(204).send();
    }

    private void getAllMembers(ServerRequest serverRequest, ServerResponse serverResponse) {
        String eventId = serverRequest.path().absolute().param("eventId");
        serverResponse.status(200).send(EventMemberList.toJsonObject(memberService.selectEventMember(UUID.fromString(eventId))));
    }
}
