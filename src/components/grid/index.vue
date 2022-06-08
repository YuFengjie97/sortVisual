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
    let arrWrap1 = ref([]) // {id,val} 排序的数组
    let arrWrap2 = ref([]) // {id,val,height,left} // 通过id与arrWrap1关联,索引顺序不变,left在变
    const transitionTime = 0.1 // 秒

    const red = "#ff7675"
    const blue = "#0984e3"
    const yellow = "#fdcb6e"

    watchEffect(() => {
      if (props.arr.length === 0) return
      max = Math.max(...props.arr.slice(0))
      arrWrap1.value = props.arr.map((item, i) => {
        return {
          id: i,
          val: item,
        }
      })
      arrWrap2.value = props.arr.map((item, i) => {
        const valH = (maxH / max) * item

        return {
          id: i,
          val: item,
          height: valH < minH ? minH : parseInt(valH),
          left: (barWidth + gap) * i,
        }
      })
    })

    function swap(arr, item1, item2, key) {
      if (item1 === item2) return
      let temp = item1[key]
      item1[key] = item2[key]
      item2[key] = temp
    }

    async function handleBubbleSort() {
      let len = arrWrap1.value.length
      for (let i = 0; i < len - 1; i++) {
        for (let j = 0; j < len - 1 - i; j++) {
          let item1 = arrWrap1.value[j]
          let item2 = arrWrap1.value[j + 1]

          let item3 = arrWrap2.value.find((item) => item.id === item1.id)
          let item4 = arrWrap2.value.find((item) => item.id === item2.id)

          item3.bg = red
          item4.bg = red

          if (item1.val > item2.val) {
            swap(arrWrap1.value, item1, item2, "id")
            swap(arrWrap1.value, item1, item2, "val")
            swap(arrWrap2.value, item3, item4, "left")
          }

          await sleep(transitionTime * 1000)
          item3.bg = blue
          item4.bg = blue
        }
      }
    }

    /**
     * item1-->item3
     * item2-->item4
     * itemMin-->item5
     */
    async function handleSelectSort() {
      let len = arrWrap1.value.length
      for (let i = 0; i < len - 1; i++) {
        let item1 = arrWrap1.value[i]
        let itemMin = item1

        let item3 = arrWrap2.value.find((item) => item.id === item1.id)
        item3.bg = red

        let item4
        let item5 = arrWrap2.value.find((item) => item.id === itemMin.id)

        for (let j = i + 1; j < len; j++) {
          let item2 = arrWrap1.value[j]
          item4 = arrWrap2.value.find((item) => item.id === item2.id)
          item4.bg = item4.id === itemMin.id ? yellow : red

          if (item2.val < itemMin.val) {
            item5.bg = blue

            itemMin = item2
            item5 = arrWrap2.value.find((item) => item.id === itemMin.id)

            item5.bg = yellow
          }

          await sleep(transitionTime * 1000)

          item4.bg = blue
        }

        swap(arrWrap1.value, item1, itemMin, "id")
        swap(arrWrap1.value, item1, itemMin, "val")
        swap(arrWrap2.value, item3, item5, "left")

        item3.bg = blue
      }
      // console.log(arrWrap1.value.map(item=>item.val));
      // console.log(arrWrap2.value.sort((a,b)=>a.left-b.left));
    }

    return () => {
      return (
        <>
          <div
            class="gridCon"
            style={{ "--transitionTime": `${transitionTime}s` }}
          >
            {arrWrap2.value.map((item, i) => {
              const styleObj = {
                width: `${barWidth}px`,
                height: `${item.height}px`,
                left: `${item.left}px`,
                background: item.bg,
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
    transition: left var(--transitionTime) ease-in;
    // transition: left 0.3s;
  }
}
</style>
