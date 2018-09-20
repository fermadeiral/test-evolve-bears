package es.upm.miw.iwvg.forge.junit;

public class User {

    private int number;

    private String name;

    private String familyName;

    public User(int number, String name, String familyName) {
        this.number = number;
        this.name = this.format(name);
        this.familyName = this.format(familyName);
    }

    private String format(String string) {
        StringBuilder builder = new StringBuilder();
        if (isNotEmpty(string)) {
            builder.append(string.trim().substring(0, 1).toUpperCase());
            if (string.length() > 1) {
                builder.append(string.substring(1).toLowerCase());
            }
        }

        return builder.toString();
    }


    public String fullName() {
        return new String("" + this.name + " " + this.familyName).trim();
    }

    public String initials() {
        return this.name.substring(0, 1) + ".";
    }

    public int getNumber() {
        return this.number;
    }

    public String getName() {
        return this.name;
    }

    public String getFamilyName() {
        return this.familyName;
    }

    public String nameToUpperCase() {
        return isNotEmpty(this.name) ? this.name.toUpperCase() : null;
    }

    private boolean isNotEmpty(String s) {
        return s != null && s.length() > 0;
    }

}
