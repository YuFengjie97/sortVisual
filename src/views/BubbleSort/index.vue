<template>
  <div class="con">
    <h1>冒泡排序</h1>
    <label class="block" for="inputStr">
      乱序数组:
      <input
        id="inputStr"
        class="w-8/12"
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
  </div>
</template>

<script setup>
import { ref, watch, watchEffect } from "vue"
import { createRandomArr } from "@/util/index"

import Grid from "@/components/grid/index.vue"

const inputStr = ref("")
const inputArr = ref([])

function updateInputArr() {
  if (inputStr.value === "") return
  inputArr.value = inputStr.value.split(",").map((item) => parseInt(item))
}

updateInputArr()
watchEffect(() => {
  updateInputArr()
})
handleCreateArr()

function handleCreateArr() {
  inputStr.value = createRandomArr(30).join(",")
}
</script>

<style lang="less" scoped>
.con {
}
</style>
