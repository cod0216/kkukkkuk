export const convertSnakeCaseToCamelCase = (str: string): string => {
  const words = str.split("_");
  const camelCaseWord = words
    .map((word, index) => {
      if (index === 0) {
        return word;
      }
      const firstLetterCap = word.charAt(0).toUpperCase();
      const remainingLetters = word.slice(1);
      return firstLetterCap + remainingLetters;
    })
    .join("");

  return camelCaseWord;
};

export const convertKeysToCamelCase = (data: any): any => {
  if (Array.isArray(data)) {
    return data.map((item) => convertKeysToCamelCase(item));
  } else if (data !== null && typeof data === "object") {
    const newObj: any = {};
    Object.keys(data).forEach((key) => {
      const newKey = convertSnakeCaseToCamelCase(key);
      newObj[newKey] = convertKeysToCamelCase(data[key]);
    });
    return newObj;
  }
  return data;
};
