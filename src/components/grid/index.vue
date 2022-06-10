<template>
  <div class="gridCon" :style="`--transitionTime: ${transitionTime}s`">
    <div
      class="item"
      v-for="item in arrWrap2"
      :key="item.id"
      :style="`height:${item.height}px;left: ${item.left}px;width:${barWidth}px;background:${item.bg}`"
    >
      {{ item.val }}
    </div>
  </div>
  <button
    class="my-2 mr-2 rounded bg-gray-900 p-1 text-white"
    @click="handleReset"
  >
    重制排序
  </button>
  <button
    class="my-2 mr-2 rounded bg-gray-900 p-1 text-white"
    @click="handleBubbleSort"
  >
    冒泡排序
  </button>
  <button
    class="my-2 mr-2 rounded bg-gray-900 p-1 text-white"
    @click="handleSelectSort"
  >
    选择排序
  </button>
  <button
    class="my-2 mr-2 rounded bg-gray-900 p-1 text-white"
    @click="handleInsertSort"
  >
    插入排序
  </button>
</template>
<script>
import { computed, ref, watchEffect } from 'vue'

import { sleep } from '@/util/index'

export default {
  props: {
    arr: {
      type: Array,
      default: () => [],
    },
  },
  setup(props) {
    let max
    let barWidth = 30
    let gap = 10
    let minH = 30
    let maxH = 400
    let arrWrap1 = [] // {id,val} 排序的数组
    let idMap = ref({}) // id-->el
    let arrWrap2 = computed(() => {
      return Object.values(idMap.value).map((item) => item)
    }) // {id,val,height,left} // 通过id与arrWrap1关联,索引顺序不变,left在变
    const transitionTime = ref(0.3) // 秒

    const active = '#ff7675'
    const defaultC = '#0984e3'
    const mark = '#fdcb6e'
    const done = '#6c5ce7'

    watchEffect(() => {
      if (props.arr.length === 0) return
      max = Math.max(...props.arr.slice(0))
      arrWrap1 = props.arr.map((item, i) => {
        return {
          id: i,
          val: item,
        }
      })
      props.arr.forEach((item, i) => {
        const valH = (maxH / max) * item
        const el = {
          id: i,
          val: item,
          height: valH < minH ? minH : parseInt(valH),
          left: (barWidth + gap) * i,
          bg: defaultC
        }
        idMap.value[i] = el
      })
    })

    function swap(item1, item2, key) {
      if (item1 === item2) return
      let temp = item1[key]
      item1[key] = item2[key]
      item2[key] = temp
    }

    function handleReset() {
      // arrWrap1 = props.arr.map((item, i) => {
      //   return {
      //     id: i,
      //     val: item,
      //   }
      // })
      // arrWrap2.value = props.arr.map((item, i) => {
      //   const valH = (maxH / max) * item
      //   const el = {
      //     id: i,
      //     val: item,
      //     height: valH < minH ? minH : parseInt(valH),
      //     left: (barWidth + gap) * i,
      //   }
      //   idMap[i] = el
      //   return el
      // })
    }

    async function handleBubbleSort() {
      let len = arrWrap1.length
      let item1, item2, item3, item4
      for (let i = 0; i < len - 1; i++) {
        for (let j = 0; j < len - 1 - i; j++) {
          item1 = arrWrap1[j]
          item2 = arrWrap1[j + 1]
          item3 = idMap.value[item1.id]
          item4 = idMap.value[item2.id]
          item3.bg = active
          item4.bg = active
          if (item1.val > item2.val) {
            swap(item1, item2, 'id')
            swap(item1, item2, 'val')
            swap(item3, item4, 'left')
          }
          await sleep(transitionTime.value * 1000)
          item3.bg = defaultC
          item4.bg = defaultC
        }
      }
    }

    /**
     * item1-->item3
     * item2-->item4
     * itemMin-->item5
     */
    async function handleSelectSort() {
      let len = arrWrap1.length
      let item1, item2, item3, item4, item5, itemMin
      for (let i = 0; i < len - 1; i++) {
        item1 = arrWrap1[i]
        itemMin = item1
        item3 = idMap.value[item1.id]
        item3.bg = mark
        item5 = idMap.value[itemMin.id]
        for (let j = i + 1; j < len; j++) {
          item2 = arrWrap1[j]
          item4 = idMap.value[item2.id]
          item4.bg = item4.id === itemMin.id ? mark : active
          if (item2.val < itemMin.val) {
            item5.bg = defaultC
            itemMin = item2
            item5 = idMap.value[itemMin.id]
            item5.bg = mark
          }
          await sleep(transitionTime.value * 1000)
          item4.bg = item4.id === itemMin.id ? mark : defaultC
        }
        swap(item1, itemMin, 'id')
        swap(item1, itemMin, 'val')
        swap(item3, item5, 'left')
        item3.bg = defaultC
        item5.bg = defaultC
      }
    }

    async function handleInsertSort() {
      let item1, item2, item3, item4
      for (let i = 1; i < arrWrap1.length; i++) {
        for (let j = i; j > 0; j--) {
          item1 = arrWrap1[j]
          item2 = arrWrap1[j - 1]

          item3 = idMap.value[item1.id]
          item4 = idMap.value[item2.id]
          item3.bg = active
          item4.bg = active
          if (item1.val < item2.val) {
            swap(item1, item2, 'val')
            swap(item1, item2, 'id')
            swap(item3, item4, 'left')
            await sleep(transitionTime.value * 1000)
            item3.bg = defaultC
            item4.bg = defaultC
          }else{
            item3.bg = defaultC
            item4.bg = defaultC
            continue
          }
        }
      }
    }
    return {
      arrWrap2,
      barWidth,
      transitionTime,
      handleReset,
      handleSelectSort,
      handleBubbleSort,
      handleInsertSort,
    }
  },
}
</script>

<style lang="less" scoped>
.gridCon {
  position: relative;
  height: 400px;
  .item {
    position: absolute;
    bottom: 0;
    background: #0984e3;
    color: #fff;
    text-align: center;
    transition: left var(--transitionTime) ease-in;
    // transition: left 0.3s;
  }
}
</style>
