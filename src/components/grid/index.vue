<script lang="jsx">
import { ref, watch, watchEffect } from "vue"
import { height } from "tailwindcss/defaultTheme"

import { sleep } from "@/util/index"

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
    let arrWrap = ref([])
    const transitionTime = 0.1 // 秒

    watchEffect(() => {
      if (props.arr.length === 0) return
      max = Math.max(...props.arr.slice(0))
      arrWrap.value = props.arr.map((item, i) => {
        const valH = (maxH / max) * item

        return {
          val: item,
          height: valH < minH ? minH : parseInt(valH),
          left: (barWidth + gap) * i,
        }
      })
      console.log({ max, arrWrap })
    })

    function swap(arr, i, j, key) {
      let temp = arr[i][key]
      arr[i][key] = arr[j][key]
      arr[j][key] = temp
    }

    async function handleBubbleSort() {
      let len = arrWrap.value.length
      for (let i = 0; i < len - 1; i++) {
        for (let j = 0; j < len - 1 - i; j++) {
          arrWrap.value[j].bg = "#ff7675"
          arrWrap.value[j + 1].bg = "#ff7675"

          if (arrWrap.value[j].val > arrWrap.value[j + 1].val) {
            swap(arrWrap.value, j, j+1, 'height')
            swap(arrWrap.value, j, j + 1, "val")
            // swap(arrWrap.value, j, j + 1, "left")
          }
          await sleep(transitionTime * 1000)
          arrWrap.value[j].bg = "#0984e3"
          arrWrap.value[j + 1].bg = "#0984e3"
        }
      }
    }

    async function handleSelectSort() {
      let len = arrWrap.value.length
      for (let i = 0; i < len; i++) {
        let minIndex = i
        let min = arrWrap.value[i].val
        for (let j = i+1; j < len; j++) {
          arrWrap.value[i].bg = "#ff7675"
          arrWrap.value[j].bg = "#ff7675"

          if (arrWrap.value[j].val < min) {
            minIndex = j
            min = arrWrap.value[j].val
          }
          await sleep(transitionTime * 1000)
          arrWrap.value[j].bg = "#0984e3"
        }
        swap(arrWrap.value, i, minIndex, 'height')
        swap(arrWrap.value, i, minIndex, "val")
        arrWrap.value[i].bg = "#0984e3"
      }
    }

    return () => {

      return (
        <>
          <div class="gridCon" style={{"--transitionTime": `${transitionTime}s`}}>
            {arrWrap.value.map((item, i) => {
              const styleObj = {
                width: `${barWidth}px`,
                height: `${item.height}px`,
                left: `${item.left}px`,
                background: item.bg
              }
              return (
                <div style={styleObj} class="item">
                  {item.val}
                </div>
              )
            })}
          </div>
          <button
            class="rounded bg-gray-900 text-white p-1 my-2 mr-2"
            onClick={handleBubbleSort}
          >
            冒泡排序
          </button>
          <button
            class="rounded bg-gray-900 text-white p-1 my-2 mr-2"
            onClick={handleSelectSort}
          >
            选择排序
          </button>
        </>
      )
    }
  },
}
</script>

<style lang="less" scoped>
.gridCon {
  border: 1px solid #000;
  position: relative;
  height: 400px;
  .item {
    position: absolute;
    bottom: 0;
    background: #0984e3;
    color: #fff;
    text-align: center;
    transition: height var(--transitionTime) ease-in;
    // transition: left 0.3s;
  }
}
</style>
