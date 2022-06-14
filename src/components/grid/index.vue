<template>
  <div class="gridCon" :style="`--transitionTime: ${transitionTime}s`">
    <div
      class="item"
      v-for="item in arrWrap2"
      :key="item.id"
      :style="`height:${item.height}px;left: ${item.left}px;width:${barWidth}px;background:${item.bg};z-index: ${item.zIndex}`"
    >
      {{ item.val }}
    </div>
  </div>
  <label class="block my-3" for="time">
    动画过渡时间(s):
    <input class="w-20" type="text" id="time" v-model="transitionTime" />
  </label>
  <button @click="handlePause">
    {{ isPause ? '继续' : '暂停' }}
  </button>
  <button @click="handleReset">重制排序</button>
  <button @click="handleBubbleSort">冒泡排序</button>
  <button @click="handleSelectSort">选择排序</button>
  <button @click="handleInsertSort">插入排序</button>
  <button @click="handleShellSort">希尔排序</button>
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
    const barWidth = 30
    const gap = 10
    const minH = 30
    const maxH = 400
    const transitionTime = ref(0.3) // 秒
    const active = '#ff7675'
    const defaultC = '#0984e3'
    const mark = '#fdcb6e'

    const colors = [
      '#00b894',
      '#00cec9',
      '#0984e3',
      '#6c5ce7',
      '#b2bec3',
      '#fdcb6e',
      '#e17055',
      '#d63031',
      '#e84393',
      '#2d3436',
    ]

    let arrWrap1 = [] // {id,val} 排序的数组
    let idMap = ref({}) // id-->el
    let arrWrap2 = computed(() => {
      return Object.values(idMap.value).map((item) => item)
    }) // {id,val,height,left} // 通过id与arrWrap1关联,索引顺序不变,left在变
    watchEffect(() => {
      if (props.arr.length === 0) return
      max = Math.max(...props.arr.slice(0))
      initDataByProp()
    })

    function initDataByProp() {
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
          bg: defaultC,
          zIndex: 1,
        }
        idMap.value[i] = el
      })
    }

    // 暂停排序
    let isPause = ref(false)
    function pause() {
      return new Promise((resolve, reject) => {
        setInterval(() => {
          if (!isPause.value) resolve()
        }, 1)
      })
    }
    function handlePause() {
      isPause.value = !isPause.value
    }

    // 结束排序
    let isOver = true

    function swap(item1, item2, key) {
      if (item1 === item2) return
      let temp = item1[key]
      item1[key] = item2[key]
      item2[key] = temp
    }

    function handleReset() {
      isOver = true
      initDataByProp()
    }

    async function handleBubbleSort() {
      isOver = false
      let len = arrWrap1.length
      let item1, item2, item3, item4
      for (let i = 0; i < len - 1; i++) {
        for (let j = 0; j < len - 1 - i; j++) {
          await pause()
          if (isOver) return
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
      isOver = false
      let len = arrWrap1.length
      let item1, item2, item3, item4, item5, itemMin
      for (let i = 0; i < len - 1; i++) {
        item1 = arrWrap1[i]
        itemMin = item1
        item3 = idMap.value[item1.id]
        item3.bg = mark
        item5 = idMap.value[itemMin.id]
        for (let j = i + 1; j < len; j++) {
          await pause()
          if (isOver) return
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
      isOver = false
      let item1, item2, item3, item4
      for (let i = 1; i < arrWrap1.length; i++) {
        for (let j = i; j > 0; j--) {
          await pause()
          if (isOver) return
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
          } else {
            item3.bg = defaultC
            item4.bg = defaultC
            continue
          }
        }
      }
    }

    async function handleShellSort() {
      let len = arrWrap1.length
      let gap = Math.floor(len / 2)
      // gap从len/2到1
      for (gap; gap > 0; gap = Math.floor(gap / 2)) {
        // 通过gap分了多少组(i)
        for (let i = 0; i < gap; i++) {
          // 每组的当前元素(j)向该组之前的元素做插入排序
          for (let j = i + gap; j < len; j += gap) {
            // 当前元素插入排序
            for (let n = j; n > i; n -= gap) {
              let itemN = arrWrap1[n]
              let itemM = arrWrap1[n - gap]
              let item3 = idMap.value[itemN.id]
              let item4 = idMap.value[itemM.id]
              item3.bg = active
              item4.bg = active
              item3.zIndex = 100
              item4.zIndex = 100

              if (itemN.val < itemM.val) {
                swap(itemN, itemM, 'id')
                swap(itemN, itemM, 'val')
                swap(item3, item4, 'left')
                await sleep(transitionTime.value * 1000)
                item3.bg = defaultC
                item4.bg = defaultC
                item3.zIndex = 1
                item4.zIndex = 1
              } else {
                await sleep(transitionTime.value * 1000)
                item3.bg = defaultC
                item4.bg = defaultC
                item3.zIndex = 1
                item4.zIndex = 1
                break
              }
            }
          }
        }
      }
    }
    return {
      isPause,
      arrWrap2,
      barWidth,
      transitionTime,
      handleReset,
      handleSelectSort,
      handleBubbleSort,
      handleInsertSort,
      handleShellSort,
      handlePause,
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
    transition: left var(--transitionTime) ease-in, color 0.3s;
  }
}
button {
  @apply my-2 mr-2 rounded bg-gray-900 p-1 text-white;
}
</style>
