export function createRandomArr(length = 10, min = 1, max = 100) {
  const ans = [];
  for (let i = 0; i < length; i++) {
    let item = parseInt(min + Math.random() * (max - min));
    ans.push(item);
  }
  return ans;
}
