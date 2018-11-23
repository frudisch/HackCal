package com.senacor.hacking.days.event.service.service;

import com.senacor.hacking.days.event.service.handler.port.User;
import com.senacor.hacking.days.event.service.repository.UserRepository;
import lombok.AllArgsConstructor;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@AllArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public void deleteUser(UUID uuid) {
        userRepository.deleteUser(uuid);
    }

    public User updateUser(UUID uuid, User event) {
        return map(userRepository.findAndReplaceUser(uuid, map(event)));
    }

    public User createUser(User event) {
        event.setUuid(UUID.randomUUID());
        userRepository.createUser(map(event));
        return event;
    }

    public List<User> getAllUsers() {
        return userRepository.selectAllUsers().stream().map(this::map).collect(Collectors.toList());
    }

    public User getUserById(UUID uuid) {
        return map(userRepository.selectUserById(uuid));
    }

    private User map(com.senacor.hacking.days.event.service.repository.domain.User user) {
        return User.builder()
                .uuid(user.getId())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .build();
    }

    private com.senacor.hacking.days.event.service.repository.domain.User map(User user) {
        return com.senacor.hacking.days.event.service.repository.domain.User.builder()
                .id(user.getUuid())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .build();
    }
}
