<template>
  <div class="con">
    <h1>冒泡排序</h1>
    <label class="block" for="inputStr">
      乱序数组:
      <input
        id="inputStr"
        class="w-2/5"
        type="text"
        placeholder="逗号隔开"
        v-model="inputStr"
      />
    </label>
    <button
      class="rounded bg-gray-900 text-white p-1 my-2"
      @click="handleCreateArr"
    >
      随机乱序
    </button>
    <div>你的输入:{{ `[${inputArr.join(", ")}]` }}</div>
    <Grid :arr="inputArr" />
    <button class="rounded bg-gray-900 text-white p-1 my-2" @click="handleSort">
      冒泡排序
    </button>
  </div>
</template>

<script setup>
import { computed, ref, watch } from "vue"
import { createRandomArr, sleep } from "@/util/index"

import Grid from "@/components/grid/index.vue"

const inputStr = ref("10,80")
const inputArr = ref([10, 80])

function updateInputArr() {
  let arr = inputStr.value.split(",").map((item) => parseInt(item))
  // inputArr.value.length = 0
  // arr.forEach(item=>{
  //     inputArr.value.push(item)
  // })
  inputArr.value = arr
}

updateInputArr()
watch(inputStr, () => {
  updateInputArr()
})
handleCreateArr()

function handleCreateArr() {
  inputStr.value = createRandomArr(20).join(",")
}
function swap(arr, i, j) {
  let temp = arr[i]
  arr[i] = arr[j]
  arr[j] = temp
}
async function handleSort() {
  let len = inputArr.value.length
  for (let i = 0; i < len - 1; i++) {
    for (let j = 0; j < len - 1 - i; j++) {
      if (inputArr.value[j] > inputArr.value[j + 1]) {
        swap(inputArr.value, j, j + 1)
        await sleep(1000)
      }
    }
  }
}
</script>

<style lang="less" scoped>
.con {
}
</style>
