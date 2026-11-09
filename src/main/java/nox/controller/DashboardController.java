package nox.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    @GetMapping("/")
    public String home() {
        return "homepage";
    }

    @GetMapping("/homepage")
    public String homepage() {
        return "homepage";
    }

    @GetMapping("/index")
    public String index() {
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }

    @GetMapping("/profile")
    public String profile() {
        return "profile";
    }

    @GetMapping("/history")
    public String history() {
        return "history";
    }

    @GetMapping("/text")
    public String text() {
        return "text";
    }

    @GetMapping("/tts")
    public String tts() {
        return "tts";
    }

    @GetMapping("/translate")
    public String translate() {
        return "translate";
    }

    @GetMapping("/summary")
    public String summary() {
        return "summary";
    }

    @GetMapping("/todolist")
    public String todolist() {
        return "todolist";
    }

    @GetMapping("/logout-page")
    public String logoutPage() {
        return "logout";
    }
}
