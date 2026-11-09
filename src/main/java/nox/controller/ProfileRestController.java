package nox.controller;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;
import nox.model.User;

@RestController
@RequestMapping("/api")
public class ProfileRestController {

    @GetMapping("/profile")
    public Map<String, Object> getProfile(HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            result.put("error", "Not logged in");
            return result;
        }

        result.put("username", user.getFullname());
        result.put("email", user.getEmail());
        return result;
    }
}
