package com.kusukaze.japanese.JMdict;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.function.Predicate;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class JMdictParser {
    private static HashMap<String, String> dictMap = new HashMap<>();
    private static HashMap<String, String> revDictMap = new HashMap<>();

    public static void generateDictionary() {
        Map<String, List<String>> data = new HashMap<>();
        Map<String, Set<String>> partOfSpeech = new HashMap<>();

        try(BufferedReader br = Files.newBufferedReader(Paths.get("src/main/resources/raw/JMdict_e"), StandardCharsets.UTF_8)) {
            String line;
            String kaki = null;

            while((line = br.readLine()) != null) {
                line = line.trim();

                if(line.startsWith("<entry>")) {
                    kaki = null;
                }

                if(line.startsWith("<keb>") && kaki == null) {
                    kaki = line.replace("</keb>", "").replace("<keb>", "");

                    if (!data.containsKey(kaki)) {
                        data.put(kaki, new ArrayList<>());
                        partOfSpeech.put(kaki, new HashSet<>());
                    }
                }
                else if(line.startsWith("<reb>")) {
                    String yomi = line.replace("</reb>", "").replace("<reb>", "");

                    if (kaki == null) {
                        kaki = yomi;
                        if (!data.containsKey(kaki)) {
                            data.put(kaki, new ArrayList<>());
                            partOfSpeech.put(kaki, new HashSet<>());
                        }
                    }

                    data.get(kaki).add(yomi);
                }
                else if(line.startsWith("<pos>")) {
                    String pos = line.replace("</pos>", "").replace("<pos>", "")
                                    .replace("&","").replace(";","");
                    partOfSpeech.get(kaki).add(pos);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        StringBuilder ans = new StringBuilder();
        int cnt = 0;

        for (Map.Entry<String, List<String>> entry : data.entrySet()) {
            cnt++;
            String kaki = entry.getKey();
            List<String> yomis = entry.getValue();
            Set<String> poses = partOfSpeech.get(kaki);

            String yomiListStr = String.join(",", yomis); // Join list elements with comma
            String posListStr = String.join(",", poses); // Join list elements with comma

            ans.append(cnt).append("\t")
                    .append(kaki).append("\t")
                    .append(yomiListStr).append("\t")
                    .append(posListStr).append("\n");
        }

        try (BufferedWriter bw = Files.newBufferedWriter(Paths.get("src/main/resources/dictionary/JMdict_e.txt"), StandardCharsets.UTF_8)) {
            bw.write(ans.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}