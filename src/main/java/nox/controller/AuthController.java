package nox.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import nox.dao.UserDAO;
import nox.model.User;

@Controller
@RequestMapping("/auth")
public class AuthController {

    private static final int MIN_PASSWORD_LENGTH = 6;
    private static final String EMAIL_REGEX = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);

    @Autowired
    private UserDAO userDAO;

    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                        @RequestParam("password") String password,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {

        List<String> errors = new ArrayList<>();

        if (email == null || email.trim().isEmpty()) {
            errors.add("Email address is required.");
        } else if (!email.trim().toLowerCase().endsWith("@gmail.com")) {
            errors.add("Only Gmail addresses (@gmail.com) are allowed.");
        }

        if (password == null || password.trim().isEmpty()) {
            errors.add("Password is required.");
        } else if (password.trim().length() < MIN_PASSWORD_LENGTH) {
            errors.add("Password must be at least " + MIN_PASSWORD_LENGTH + " characters long.");
        }

        if (!errors.isEmpty()) {
            redirectAttributes.addAttribute("errors", String.join("||", errors));
            return "redirect:/login";
        }

        User user = userDAO.loginUser(email.trim().toLowerCase(), password);

        if (user != null) {
            session.setAttribute("currentUser", user);
            session.setAttribute("userName", user.getFullname());
            session.setAttribute("userId", user.getId());
            return "redirect:/index";
        } else {
            errors.add("Invalid email address or password. Please try again.");
            redirectAttributes.addAttribute("errors", String.join("||", errors));
            redirectAttributes.addAttribute("field", "auth");
            return "redirect:/login";
        }
    }

    @PostMapping("/register")
    public String register(@RequestParam("fullname") String fullname,
                           @RequestParam("email") String email,
                           @RequestParam("password") String password,
                           @RequestParam("confirmPassword") String confirmPassword,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {

        List<String> errors = new ArrayList<>();

        if (fullname == null || fullname.trim().isEmpty()) {
            errors.add("Full name is required.");
        }
        if (email == null || email.trim().isEmpty()) {
            errors.add("Email address is required.");
        }
        if (password == null || password.trim().isEmpty()) {
            errors.add("Password is required.");
        }
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.add("Confirm password is required.");
        }

        if (fullname != null && !fullname.trim().isEmpty() && fullname.trim().length() < 2) {
            errors.add("Full name must be more than 1 character.");
        }

        if (email != null && !email.trim().isEmpty()) {
            String trimmedEmail = email.trim().toLowerCase();

            if (!EMAIL_PATTERN.matcher(trimmedEmail).matches()) {
                errors.add("Invalid email format.");
            } else if (trimmedEmail.endsWith("@gmal.com") ||
                       trimmedEmail.endsWith("@gamil.com") ||
                       trimmedEmail.endsWith("@gmial.com") ||
                       trimmedEmail.endsWith("@gmail.co") ||
                       trimmedEmail.endsWith("@gmail.om") ||
                       trimmedEmail.endsWith("@gmail.cmo") ||
                       trimmedEmail.endsWith("@gmail.cok") ||
                       trimmedEmail.endsWith("@gmail.con") ||
                       trimmedEmail.endsWith("@gmailcom") ||
                       trimmedEmail.endsWith("@gmaill.com") ||
                       trimmedEmail.endsWith("@gmaol.com") ||
                       trimmedEmail.endsWith("@gmil.com") ||
                       trimmedEmail.endsWith("@gmail.vom") ||
                       trimmedEmail.endsWith("@gmail.cim") ||
                       trimmedEmail.endsWith("@gmaul.com") ||
                       trimmedEmail.endsWith("@gmaik.com") ||
                       trimmedEmail.endsWith("@gmeil.com") ||
                       trimmedEmail.endsWith("@gmsil.com") ||
                       trimmedEmail.endsWith("@gmail.cpm") ||
                       trimmedEmail.endsWith("@gmail.coom")) {
                errors.add("Did you mean @gmail.com? Please fix the email domain spelling.");
            } else if (userDAO.isEmailRegistered(trimmedEmail)) {
                errors.add("This email address is already registered. Please use a different email.");
            }
        }

        if (password != null && confirmPassword != null && !password.equals(confirmPassword)) {
            errors.add("Passwords do not match.");
        }

        if (!errors.isEmpty()) {
            redirectAttributes.addAttribute("errors", String.join("||", errors));
            redirectAttributes.addAttribute("fullname", fullname);
            redirectAttributes.addAttribute("email", email);
            return "redirect:/register";
        }

        User newUser = new User(fullname.trim(), email.trim().toLowerCase(), password);
        boolean isRegistered = userDAO.registerUser(newUser);

        if (isRegistered) {
            session.setAttribute("currentUser", newUser);
            session.setAttribute("userName", newUser.getFullname());
            return "redirect:/login";
        } else {
            redirectAttributes.addAttribute("errors", "Registration failed due to a server error. Please try again.");
            return "redirect:/register";
        }
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/homepage";
    }
}
