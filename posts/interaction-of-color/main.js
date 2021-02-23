if (Color.default) {
  window.Color = Color.default;
}

// const colorspace = "jzczhz";
// const maxFallbackValue = 0.22;
// const maxFallbackChroma = 0.18;
// const maxFallbackHue = 360;
const colorspace = "lch";
const maxFallbackValue = 100;
const maxFallbackChroma = 150;
const maxFallbackHue = 360;

const steps = 32;

const e = React.createElement;

// const numSamples = 100;
// Derive fallback max value
// let maxFallbackValue = 0
// let maxFallbackChroma = 0
// let maxFallbackHue = 0
// for (let x = 0; x < numSamples; x++) {
//   for (let y = 0; y < numSamples; y++) {
//     for (let z = 0; z < numSamples; z++) {
//       let xShift = (x / numSamples) * maxValue;
//       let yShift = (y / numSamples) * maxChroma;
//       let zShift = (z / numSamples) * maxHue;
//       let color = new Color(colorspace, [
//         xShift,
//         yShift,
//         zShift,
//       ]);
//       // let cssColor = color.toString({ fallback: true });
//       // let inGamut = cssColor.color.inGamut();
//       if (color.inGamut("srgb")) {
//         if (xShift > maxFallbackValue) {
//           maxFallbackValue = xShift
//         }
//         if (yShift > maxFallbackChroma) {
//           maxFallbackChroma = yShift
//         }
//         if (zShift > maxFallbackHue) {
//           maxFallbackHue = zShift
//         }
//       }
//     }
//   }
// }
function useWindowWidth() {
  let [width, setWidth] = React.useState(window.innerWidth);
  let callback = React.useCallback(() => setWidth(window.innerWidth), [setWidth]);
  React.useEffect(() => {
    window.addEventListener("resize", callback);
    return () => window.removeEventListener(callback);
  }, [callback]);
  return width;
}

function DraggableCaret(props) {
  let { containerRef, index, setIndex } = props;

  let windowWidth = useWindowWidth();

  // Calculate the width of our container, we recompute when the window width
  // changes. This is not quire correct, but it is a reasonable placeholder
  // for detecting changes to our container.
  let [containerBoundingRect, setContainerBoundingRect] = React.useState(null);
  React.useEffect(() => {
    if (containerRef.current == null) {
      return null;
    }
    setContainerBoundingRect(containerRef.current.getBoundingClientRect());
  }, [containerRef.current, windowWidth]);

  let [dragX, setDragX] = React.useState(null);
  let caretDragWidth = containerBoundingRect && containerBoundingRect.width;

  let swatchWidth =
    containerBoundingRect && containerBoundingRect.width / steps;
  let useDragCallback = React.useCallback(
    (state) => {
      let clientX = Math.min(
        Math.max(state.xy[0], containerBoundingRect.x + swatchWidth / 2),
        containerBoundingRect.x + containerBoundingRect.width - swatchWidth / 2
      );
      let caretPosition = clientX - containerBoundingRect.x;
      let newIndex = Math.floor(caretPosition / swatchWidth);
      setIndex(newIndex);
      if (state.last) {
        setDragX(swatchWidth * (newIndex + 0.5) + containerBoundingRect.x);
      } else {
        setDragX(clientX);
      }
    },
    [containerBoundingRect, setIndex, swatchWidth]
  );
  let bind = ReactUseGesture.useDrag(useDragCallback);
  if (containerBoundingRect == null) {
    return null;
  }
  dragX = dragX ?? swatchWidth * (index + 0.5) + containerBoundingRect.x;
  let leftTransform = dragX - containerBoundingRect.x - caretDragWidth / 2;
  return e(
    "div",
    {
      ...bind(),
      style: {
        // Prevent the absolute positioned caret from being dragged beyond bounds
        overflow: "hidden",
        position: "absolute",
        cursor: "grab",
        width: "100%",
        height: "32px",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
      },
    },
    e("div", {
      style: {
        position: "absolute",
        transform: `translate(${leftTransform}px, 0)`,
        width: "4px",
        height: "32px",
        backgroundColor: "black",
      },
    })
  );
}

function ColorScaleAxis(props) {
  let { index, setIndex } = props;
  let ref = React.useRef(null);
  let caret = e(DraggableCaret, { index, setIndex, containerRef: ref });
  return e(
    "div",
    {
      ref,
      style: {
        height: "30px",
        position: "relative",
        display: "flex",
        alignItems: "center",
        justifyContent: "space-between",
      },
    },
    [caret, ...props.children]
  );
}

function ColorScale(props) {
  let {
    showValue,
    showChroma,
    showHue,
    hueIndex,
    setHueIndex,
    chromaIndex,
    setChromaIndex,
    valueIndex,
    setValueIndex,
  } = props;
  let width = `calc(100% / ${steps})`;
  let height = "24px";
  let hueDivs = Array.from({ length: steps }).map((_, index) => {
    let color = colorFromIndexes({
      hueIndex: index,
      chromaIndex,
      valueIndex,
    });
    return e("div", {
      key: index,
      style: {
        backgroundColor: color,
        height,
        width,
      },
    });
  });
  let chromaDivs = Array.from({ length: steps }).map((_, index) => {
    let color = colorFromIndexes({
      chromaIndex: index,
      hueIndex,
      valueIndex,
    });
    return e("div", {
      key: index,
      style: {
        backgroundColor: color,
        height,
        width,
      },
    });
  });
  let valueDivs = Array.from({ length: steps }).map((_, index) => {
    let color = colorFromIndexes({
      valueIndex: index,
      chromaIndex,
      hueIndex,
    });
    return e("div", {
      key: index,
      style: {
        backgroundColor: color,
        height,
        width,
      },
    });
  });

  let axes = [];
  if (showHue) {
    axes.push(
      e(
        ColorScaleAxis,
        { key: "hue", index: hueIndex, setIndex: setHueIndex },
        hueDivs
      )
    );
  }
  if (showChroma) {
    axes.push(
      e(
        ColorScaleAxis,
        { key: "chroma", index: chromaIndex, setIndex: setChromaIndex },
        chromaDivs
      )
    );
  }
  if (showValue) {
    axes.push(
      e(
        ColorScaleAxis,
        { key: "value", index: valueIndex, setIndex: setValueIndex },
        valueDivs
      )
    );
  }

  return e(
    "div",
    { style: { display: "flex", flexDirection: "column" } },
    axes
  );
}

function colorFromIndexes({ hueIndex, chromaIndex, valueIndex }) {
  let hueShift = (hueIndex / (steps - 1)) * maxFallbackHue;
  let chromaShift = (chromaIndex / (steps - 1)) * maxFallbackChroma;
  let valueShift = (valueIndex / (steps - 1)) * maxFallbackValue;
  let rawColor = new Color(colorspace, [valueShift, chromaShift, hueShift]);
  let color;
  if (!rawColor.inGamut("srgb")) {
    color = "white";
  } else {
    color = rawColor.to("srgb");
  }
  return color;
}

function randomBetween(start, end) {
  return start + Math.random() * (end - start);
}

const HUE_TAB = 0;
const CHROMA_TAB = 1;
const VALUE_TAB = 2;

function App(props) {
  // svg viewbox units
  const width = 100;
  const height = 50;
  const squareWidth = 8;

  let [selectedTab, setSelectedTab] = React.useState(
    props.selectedTab ?? HUE_TAB
  );
  let [showControls, setShowControls] = React.useState(false);

  let initialLeftHalfBgHueIndex = React.useMemo(
    () => props.left?.hueIndex ?? Math.floor(Math.random() * steps),
    [props.left?.hueIndex]
  );
  let initialRightHalfBgHueIndex = React.useMemo(() => {
    return (
      props.right?.hueIndex ??
      Math.floor(initialLeftHalfBgHueIndex + steps / 4) % steps
    );
  }, [props.right?.hueIndex, initialLeftHalfBgHueIndex]);
  let initialSquareBgHueIndex = React.useMemo(() => {
    return (
      props.square?.hueIndex ??
      Math.floor(initialLeftHalfBgHueIndex + steps / 8) % steps
    );
  }, [props.square?.hueIndex, initialLeftHalfBgHueIndex]);
  // let initialRightHalfBgHueIndex = React.useMemo(() => {
  //   let offset = randomBetween(0.6 * steps, 0.8 * steps) * 0.5;
  //   return Math.floor(initialLeftHalfBgHueIndex + offset) % steps;
  // }, [initialLeftHalfBgHueIndex]);
  // let initialSquareBgHueIndex = React.useMemo(() => {
  //   let offset = randomBetween(0.2 * steps, 0.5 * steps) * 0.5;
  //   return Math.floor(initialLeftHalfBgHueIndex + offset) % steps;
  // }, [initialLeftHalfBgHueIndex]);

  let [leftHalfBgHueIndex, setLeftHalfBgHueIndex] = React.useState(
    initialLeftHalfBgHueIndex
  );
  let [leftHalfBgChromaIndex, setLeftHalfBgChromaIndex] = React.useState(
    props.left?.chromaIndex ?? Math.floor(0.2 * steps)
  );
  let [leftHalfBgValueIndex, setLeftHalfBgValueIndex] = React.useState(
    props.left?.valueIndex ?? Math.floor(0.6 * steps)
  );

  let leftHalfBgColor = colorFromIndexes({
    hueIndex: leftHalfBgHueIndex,
    chromaIndex: leftHalfBgChromaIndex,
    valueIndex: leftHalfBgValueIndex,
  });
  let [rightHalfBgHueIndex, setRightHalfBgHueIndex] = React.useState(
    initialRightHalfBgHueIndex
  );
  let [rightHalfBgChromaIndex, setRightHalfBgChromaIndex] = React.useState(
    props.right?.chromaIndex ?? Math.floor(0.2 * steps)
  );
  let [rightHalfBgValueIndex, setRightHalfBgValueIndex] = React.useState(
    props.right?.valueIndex ?? Math.floor(0.6 * steps)
  );
  let rightHalfBgColor = colorFromIndexes({
    hueIndex: rightHalfBgHueIndex,
    chromaIndex: rightHalfBgChromaIndex,
    valueIndex: rightHalfBgValueIndex,
  });
  let [squareBgHueIndex, setSquareBgHueIndex] = React.useState(
    initialSquareBgHueIndex
  );
  let [squareBgChromaIndex, setSquareBgChromaIndex] = React.useState(
    props.square?.chromaIndex ?? Math.floor(0.2 * steps)
  );
  let [squareBgValueIndex, setSquareBgValueIndex] = React.useState(
    props.square?.valueIndex ?? Math.floor(0.6 * steps)
  );
  let squareBgColor = colorFromIndexes({
    hueIndex: squareBgHueIndex,
    chromaIndex: squareBgChromaIndex,
    valueIndex: squareBgValueIndex,
  });

  // console.log("left", [leftHalfBgHueIndex, leftHalfBgChromaIndex, leftHalfBgValueIndex], "right", [rightHalfBgHueIndex, rightHalfBgChromaIndex, rightHalfBgValueIndex], "square", [squareBgHueIndex, squareBgChromaIndex, squareBgValueIndex])

  return e("div", {}, [
    e(
      "div",
      {
        onClick: () => setShowControls((state) => !state),
        style: { position: "relative", cursor: "pointer" },
      },
      [
        e(
          "i",
          {
            className: "fas fa-hand-pointer",
            style: {
              position: "absolute",
              right: "22px",
              // color: "white",
              color: "rgba(255, 255, 255, 0.6)",
              fontSize: "24px",
              top: "22px",
            },
          },
          []
        ),
        e(
          "svg",
          {
            style: {
              display: "block",
              marginBottom: "16px",
              borderRadius: "4px",
            },
            width: "100%",
            viewBox: `0 0 ${width} ${height}`,
          },
          [
            // Provide 1px greater than half width, to prevent bg from seeping
            // through
            e("rect", { fill: leftHalfBgColor, width: width / 2 + 1, height }),
            e("rect", {
              fill: rightHalfBgColor,
              x: width / 2,
              width: width / 2,
              height,
            }),
            e("rect", {
              fill: squareBgColor,
              x: width / 4 - squareWidth / 2,
              y: height / 2 - squareWidth / 2,
              width: squareWidth,
              height: squareWidth,
            }),
            e("rect", {
              fill: squareBgColor,
              x: (width * 3) / 4 - squareWidth / 2,
              y: height / 2 - squareWidth / 2,
              width: squareWidth,
              height: squareWidth,
            }),
          ]
        ),
      ]
    ),
    showControls
      ? e("div", {}, [
          e(
            "div",
            {
              style: {
                fontFamily: "monospace",
                fontSize: "16px",
                userSelect: "none",
                fontWeight: 700,
                textTransform: "uppercase",
                display: "flex",
                justifyContent: "flex-end",
                marginBottom: "16px",
              },
            },
            [
              e(
                "div",
                {
                  onClick: () => setSelectedTab(HUE_TAB),
                  style: {
                    opacity: selectedTab === HUE_TAB ? 1 : 0.5,
                    cursor: "pointer",
                    marginRight: "8px",
                  },
                },
                "Hue"
              ),
              e(
                "div",
                {
                  onClick: () => setSelectedTab(CHROMA_TAB),
                  style: {
                    opacity: selectedTab === CHROMA_TAB ? 1 : 0.5,
                    cursor: "pointer",
                    marginRight: "8px",
                  },
                },
                "Chroma"
              ),
              e(
                "div",
                {
                  onClick: () => setSelectedTab(VALUE_TAB),
                  style: {
                    opacity: selectedTab === VALUE_TAB ? 1 : 0.5,
                    cursor: "pointer",
                    marginRight: "8px",
                  },
                },
                "Value"
              ),
            ]
          ),
          e(
            "div",
            { style: { marginBottom: "16px" } },
            e(
              ColorScale,
              {
                key: "leftHalfBg",
                showHue: selectedTab === HUE_TAB,
                showChroma: selectedTab === CHROMA_TAB,
                showValue: selectedTab === VALUE_TAB,
                hueIndex: leftHalfBgHueIndex,
                setHueIndex: setLeftHalfBgHueIndex,
                chromaIndex: leftHalfBgChromaIndex,
                setChromaIndex: setLeftHalfBgChromaIndex,
                valueIndex: leftHalfBgValueIndex,
                setValueIndex: setLeftHalfBgValueIndex,
              },
              null
            )
          ),
          e(
            "div",
            { style: { marginBottom: "16px" } },
            e(
              ColorScale,
              {
                key: "rightHalfBg",
                showHue: selectedTab === HUE_TAB,
                showChroma: selectedTab === CHROMA_TAB,
                showValue: selectedTab === VALUE_TAB,
                hueIndex: rightHalfBgHueIndex,
                setHueIndex: setRightHalfBgHueIndex,
                chromaIndex: rightHalfBgChromaIndex,
                setChromaIndex: setRightHalfBgChromaIndex,
                valueIndex: rightHalfBgValueIndex,
                setValueIndex: setRightHalfBgValueIndex,
              },
              null
            )
          ),
          e(
            "div",
            { style: { marginBottom: "16px" } },
            e(
              ColorScale,
              {
                key: "squareBg",
                showHue: selectedTab === HUE_TAB,
                showChroma: selectedTab === CHROMA_TAB,
                showValue: selectedTab === VALUE_TAB,
                hueIndex: squareBgHueIndex,
                setHueIndex: setSquareBgHueIndex,
                chromaIndex: squareBgChromaIndex,
                setChromaIndex: setSquareBgChromaIndex,
                valueIndex: squareBgValueIndex,
                setValueIndex: setSquareBgValueIndex,
              },
              null
            )
          ),
        ])
      : null,
  ]);
}

ReactDOM.render(
  e(App, {
    left: {
      hueIndex: (2 / 16) * steps,
      valueIndex: (10 / 16) * steps,
      chromaIndex: (6 / 16) * steps,
    },
    right: {
      hueIndex: (6 / 16) * steps,
      valueIndex: (10 / 16) * steps,
      chromaIndex: (6 / 16) * steps,
    },
    square: {
      hueIndex: (4 / 16) * steps,
      valueIndex: (10 / 16) * steps,
      chromaIndex: (6 / 16) * steps,
    },
  }),
  document.querySelector("#root")
);

ReactDOM.render(
  e(App, {
    selectedTab: VALUE_TAB,
    left: {
      hueIndex: (2 / 16) * steps,
      valueIndex: (6 / 16) * steps,
      chromaIndex: (0 / 16) * steps,
    },
    right: {
      hueIndex: (6 / 16) * steps,
      valueIndex: (10 / 16) * steps,
      chromaIndex: (0 / 16) * steps,
    },
    square: {
      hueIndex: (4 / 16) * steps,
      valueIndex: (8 / 16) * steps,
      chromaIndex: (0 / 16) * steps,
    },
  }),
  document.querySelector("#black-and-white")
);

ReactDOM.render(
  e(App, {
    selectedTab: CHROMA_TAB,
    left: {
      hueIndex: (12 / 16) * steps,
      valueIndex: (8 / 16) * steps,
      chromaIndex: (7 / 16) * steps,
    },
    right: {
      hueIndex: (12 / 16) * steps,
      valueIndex: (8 / 16) * steps,
      chromaIndex: (0 / 16) * steps,
    },
    square: {
      hueIndex: (12 / 16) * steps,
      valueIndex: (8 / 16) * steps,
      chromaIndex: (3 / 16) * steps,
    },
  }),
  document.querySelector("#chroma")
);

// left (3) [3, 15, 16] right (3) [24, 0, 16] square (3) [24, 15, 16]

ReactDOM.render(
  e(App, {
    selectedTab: CHROMA_TAB,
    left: {
      hueIndex: (3 / 32) * steps,
      chromaIndex: (15 / 32) * steps,
      valueIndex: (16 / 32) * steps,
    },
    right: {
      hueIndex: (24 / 32) * steps,
      chromaIndex: (0 / 32) * steps,
      valueIndex: (16 / 32) * steps,
    },
    square: {
      hueIndex: (24 / 32) * steps,
      chromaIndex: (15 / 32) * steps,
      valueIndex: (16 / 32) * steps,
    },
  }),
  document.querySelector("#complementary")
);

// let stroke = 10
// let gap = 0;
// let zoom = 1.5;

// // create illo
// let illo = new Zdog.Illustration({
//   // set canvas with selector
//   element: ".zdog-canvas",
//   resize: true,
//   dragRotate: true,
//   zoom,
// });

// let n = 20;
// let totalWidth = n * stroke  - 2 * stroke + (n - 1) * gap
// let allColors = [];
// for (let x = 0; x < n; x++) {
//   for (let z = 0; z < n; z++) {
//     for (let y = 0; y < n/2; y++) {
//       let hueShift = ((n-1) / (n - 1)) * maxFallbackHue;
//       let chromaShift = (0 / (n - 1)) * maxFallbackChroma;
//       let valueShift = maxFallbackValue - (y / (n/2 - 1)) * maxFallbackValue;
//       let shiftedZ = z * stroke - totalWidth / 2
//       let shiftedX = x * stroke - totalWidth / 2
//       let hueDeg;
//       let hueAngle = 180 / Math.PI * Math.atan(shiftedZ / shiftedX)
//       if ( shiftedX >= 0 && shiftedZ >= 0) {
//       } else if ( shiftedX <= 0 && shiftedZ >= 0) {
//         hueAngle = 180 + hueAngle
//       } else if ( shiftedX < 0 && shiftedZ <= 0) {
//         hueAngle += 180
//       } else {
//         hueAngle = 360 + hueAngle
//       }
//       let tangent = Math.sqrt(shiftedX ** 2 + shiftedZ ** 2)
//       let rawColor = new Color(colorspace, [valueShift, tangent / (totalWidth / 2) * maxFallbackChroma, hueAngle]);
//       let color;
//       if (!rawColor.inGamut("srgb")) {
//         continue;
//       } else {
//         color = rawColor.to("srgb");
//         allColors.push(color)
//       }
//       new Zdog.Shape({
//         addTo: illo,
//         stroke,
//         // diameter: cylinderDiameter,
//         // length: cylinderLength,
//         // rotate: { x: Zdog.TAU / 4 },
//         translate: {
//           z: shiftedZ,
//           x: shiftedX,
//           y: y * (gap + 2 * stroke) - totalWidth / 2,
//         },
//         // stroke: false,
//         // color: x === Math.floor(n/2) && y === Math.floor(n/2) && z === Math.floor(n/2) ? "red" : "#ccc",
//         color
//       });
//     }
//   }
// }
// window.x = allColors;

// illo.rotate.x -= Zdog.TAU / 16;
// illo.rotate.y -= Zdog.TAU / 16;

// function animate() {
//   // rotate illo each frame
//   illo.rotate.y += 0.01;
//   // illo.rotate.x += 0.03;
//   // illo.rotate.z += 0.03;
//   illo.updateRenderGraph();
//   // animate next frame
//   requestAnimationFrame(animate);
// }
// // start animation
// animate();
