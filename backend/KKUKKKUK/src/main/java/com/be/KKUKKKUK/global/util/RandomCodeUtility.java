package com.be.KKUKKKUK.global.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.global.util<br>
 * fileName       : RandomCodeUtility.java<br>
 * author         : haelim <br>
 * date           : 2025-03-18<br>
 * description    : 랜덤 코드 생성을 위한 유틸 클래스입니다. <br>
 * 객체 생성 없이 호출할 수 있도록 static 으로 선언하고 생성자 없이 동작합니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 2025-03-18        haelim            최초생성<br>
 */
public final class RandomCodeUtility {
    private static final String UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String DIGITS = "0123456789";
    private static final String SPECIALS = "!@#$%^&*";
    private static final String ALL_CHARS = UPPERCASE + LOWERCASE + DIGITS + SPECIALS;
    private static final SecureRandom RANDOM;

    /**
     * 랜덤 인증 코드를 생성합니다. (숫자)
     * @param length 인증 코드 길이
     * @return 랜덤한 인증 코드
     */
    public static String generateCode(int length) {
        return generateRandomString(DIGITS, length);
    }

    /**
     * 비밀번호를 생성합니다 (영문 대소문자, 숫자, 특수문자 조합)
     * @param length 비밀번호 길이 (최소 4 이상)
     * @return 랜덤 비밀번호
     */
    public static String generatePassword(int length) {
        if (length < 4) throw new IllegalArgumentException("비밀번호는 최소 4자 이상이어야 합니다.");

        StringBuilder password = new StringBuilder();
        password.append(getRandomCharacter(UPPERCASE));
        password.append(getRandomCharacter(LOWERCASE));
        password.append(getRandomCharacter(DIGITS));
        password.append(getRandomCharacter(SPECIALS));

        for (int i = 4; i < length; i++) {
            password.append(getRandomCharacter(ALL_CHARS));
        }

        return shuffleString(password.toString());
    }

    /**
     * 주어진 문자 집합에서 랜덤 문자열을 생성합니다.
     * @param characters 사용할 문자 집합
     * @param length 문자열 길이
     * @return 랜덤 문자열
     */
    private static String generateRandomString(String characters, int length) {
        StringBuilder builder = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            builder.append(getRandomCharacter(characters));
        }
        return builder.toString();
    }

    /**
     * 주어진 문자 집합에서 랜덤으로 한 문자를 반환합니다.
     * @param characters 문자 집합
     * @return 랜덤 문자
     */
    private static char getRandomCharacter(String characters) {
        return characters.charAt(RANDOM.nextInt(characters.length()));
    }

    /**
     * 문자열을 무작위로 섞는 메소드입니다.
     * @param input 문자열
     * @return 섞인 문자열
     */
    private static String shuffleString(String input) {
        List<Character> characters = new ArrayList<>();
        for (char c : input.toCharArray()) {
            characters.add(c);
        }
        Collections.shuffle(characters, RANDOM);
        StringBuilder shuffledString = new StringBuilder();
        for (char c : characters) {
            shuffledString.append(c);
        }
        return shuffledString.toString();
    }

    /**
     * 객체 생성을 방지하기 위한 private 생성자입니다.
     */
    private RandomCodeUtility() {
        throw new UnsupportedOperationException("Utility Class");
    }

    static {
        try {
            RANDOM = SecureRandom.getInstanceStrong();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SecureRandom instance 생성 실패", e);
        }
    }
}
